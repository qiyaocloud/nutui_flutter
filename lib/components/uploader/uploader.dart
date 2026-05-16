import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutui_flutter/theme/colors.dart';

import '../icon/icon.dart';

enum NutUploadStatus {
  ready,
  uploading,
  done,
  failed,
}

class NutUploadFile {
  // 远程 URL (用于展示已上传的图片)
  final String? url;

  // 本地路径 (用于展示刚选中的图片)
  final String? path;

  // 当前状态
  final NutUploadStatus status;

  // 提示信息 (如上传失败时的文本)
  final String? message;

  const NutUploadFile({
    this.url,
    this.path,
    this.status = NutUploadStatus.done,
    this.message,
  });

  // 获取用于展示的 ImageProvider
  ImageProvider get imageProvider {
    if (path != null && path!.isNotEmpty) {
      return FileImage(File(path!));
    }
    if (url != null && url!.isNotEmpty) {
      return NetworkImage(url!);
    }
    return const AssetImage('');
  }
}

class NutUploader extends StatefulWidget {
  // 当前文件列表
  final List<NutUploadFile> value;

  // 值改变回调
  final ValueChanged<List<NutUploadFile>> onChanged;

  // 最大上传数量
  final int maxCount;

  // 单个文件最大大小 (字节)，0表示不限制 (需在 onPickFile 中自行判断)
  final int maxSize;

  // 是否禁用
  final bool disabled;

  // 是否在点击预览图后展示全屏预览 (简单实现，可外部拦截)
  final bool previewFullImage;

  // 触发选择文件的回调
  // 返回选中的本地文件路径列表
  final Future<List<String>> Function() onPickFile;

  // 实际上传逻辑回调
  // 接收本地文件路径，需返回上传后的远程 URL
  // 如果上传失败，请抛出异常
  final Future<String> Function(String localPath) onUpload;

  const NutUploader({
    super.key,
    required this.value,
    required this.onChanged,
    required this.onPickFile,
    required this.onUpload,
    this.maxCount = 9,
    this.maxSize = 0,
    this.disabled = false,
    this.previewFullImage = true,
  });

  @override
  State<NutUploader> createState() => _NutUploaderState();
}

class _NutUploaderState extends State<NutUploader> {
  // 点击添加按钮
  Future<void> _handleAdd() async {
    if (widget.disabled) return;
    try {
      // 获取本地文件路径
      final List<String> paths = await widget.onPickFile();
      if (paths.isEmpty) return;

      List<NutUploadFile> currentList = List.from(widget.value);

      for (var path in paths) {
        if (currentList.length >= widget.maxCount) break;

        // 插入一条 “上传中”的记录
        final file = NutUploadFile(
          path: path,
          status: NutUploadStatus.uploading,
          message: '上传中',
        );
        currentList.add(file);
        widget.onChanged(currentList); // 立即刷新UI显示上传中
        _doUpload(currentList, path, currentList.length - 1);
      }
    } catch (e) {
      debugPrint('选择文件失败: $e');
    }
  }

  // 执行上传逻辑
  Future<void> _doUpload(List<NutUploadFile> list, String localPath, int index) async {
    try {
      // 调用上传接口
      final String remoteUrl = await widget.onUpload(localPath);

      // 上传成功，更新记录
      if (mounted && index < list.length) {
        list[index] = NutUploadFile(
          url: remoteUrl,
          path: localPath,
          status: NutUploadStatus.done,
        );
        widget.onChanged(List.from(list));
      }
    } catch (e) {
      // 上传失败，更新记录
      if (mounted && index < list.length) {
        list[index] = NutUploadFile(
          path: localPath,
          status: NutUploadStatus.failed,
          message: '上传失败',
        );
        widget.onChanged(List.from(list));
      }
    }
  }

  // 删除文件
  void _handleDelete(int index) {
    List<NutUploadFile> currentList = List.from(widget.value);
    currentList.removeAt(index);
    widget.onChanged(currentList);
  }
  
  // 点击预览
  void _handlePreview(NutUploadFile file) {
    if (widget.disabled) return;
    // 简单的全凭图片预览
    if (widget.previewFullImage && (file.url != null || file.path != null)) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Image(image: file.imageProvider),
          ),
        );
      }));
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // 渲染已选/已传文件
        for (int i = 0; i < widget.value.length; i++)
          _buildItem(widget.value[i], i),
        
        // 渲染添加按钮
        if (widget.value.length < widget.maxCount) _buildAddButton(),
      ],
    );
  }
  
  // 单个文件 UI
  Widget _buildItem(NutUploadFile file, int index) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          // 图片本体
          GestureDetector(
            onTap: () => _handlePreview(file),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: file.imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // 状态遮罩（上传中/失败）
          if (file.status == NutUploadStatus.uploading ||
              file.status == NutUploadStatus.failed)
            Container(
              decoration: BoxDecoration(
                color: NutUIColors.mask,
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: file.status == NutUploadStatus.uploading
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(NutUIColors.white),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('上传中', style: TextStyle(color: NutUIColors.white, fontSize: 10)),
                  ],
              ) : Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  NutIcon(icon: NutIcons.circleClose, color: Colors.white, size: 20),
                  SizedBox(height: 4),
                  Text('上传失败', style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),

          // 删除按钮（不在上传时显示）
          if (!widget.disabled && file.status != NutUploadStatus.uploading)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _handleDelete(index),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: NutUIColors.mask,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: const NutIcon(icon: NutIcons.close, size: 14, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 添加按钮 UI
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _handleAdd,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: NutUIColors.border, width: 1, strokeAlign: BorderSide.strokeAlignInside),
        ),
        child: const NutIcon(icon: NutIcons.add, size: 24, color: NutUIColors.textSecondary),
      ),
    );
  }
}