import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wan/base/BaseState.dart';
import 'package:flutter_wan/common/values.dart';
import 'package:flutter_wan/util/Extension.dart';
import 'package:flutter_wan/util/UiUtils.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebUrl {
  String url;
  String? title;

  WebUrl(this.url, this.title);
}

class WebViewPage extends StatefulWidget {
  final String url;
  final String? title;

  WebViewPage(this.url, this.title);

  @override
  State<StatefulWidget> createState() {
    return WebViewState(url, title);
  }
}

class WebViewState<WebViewPage> extends BaseState {
  String _title = "加载中...";
  String? _articleTitle;
  double _progress = 0;
  bool _progressVisible = true;
  String url;

  WebViewState(this.url, this._articleTitle);

  WebViewController? _controller;

  @override
  Widget getLayout() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorRes.textColorPrimary,),
          onPressed: () async {
            bool canGoBack = await _controller?.canGoBack() ?? false;
            if (canGoBack)
              await _controller?.goBack();
            else
              Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 50.w,
        title: UiUtils.htmlText(_title, 18.sp, ColorRes.textColorPrimary, maxLines: 1),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _progress,
              minHeight: 3.w,
              backgroundColor: ColorRes.progressBg,
              valueColor: AlwaysStoppedAnimation(ColorRes.progressValueColor),
            ).visible(_progressVisible),
            getWebView().expanded(),
          ],
        ),
      ),
    );
  }

  @override
  void initData() {}

  /// 针对iOS，需要在ios-Runner-info.plist中添加
  /// <key>io.flutter.embedded_views_preview</key>
  /// <string>YES</string>
  Widget getWebView() {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _controller = controller;
        _controller?.clearCache();
        _controller?.loadUrl(url);
      },
      onProgress: (progress) {
        setState(() {
          _progress = progress.toDouble() / 100;
        });
      },
      onPageStarted: (url) async {
        String? title = await _controller?.getTitle();
        if (title != null && title.isNotEmpty) {
          setState(() {
            _title = title;
          });
        }
      },
      onPageFinished: (url) async {
        String? title = await _controller?.getTitle();
        if (title != null && title.isNotEmpty) {
          setState(() {
            if (_articleTitle == null || _articleTitle!.isEmpty) {
              _title = title;
            } else if (title.startsWith("http:") || title.startsWith("https:")) {
              _title = _articleTitle!;
            }
            _progressVisible = false;
          });
        }
      },
      navigationDelegate: (nav) {
        if (nav.url.startsWith("http:") || nav.url.startsWith("https:")) {
          return NavigationDecision.navigate;
        }
        return NavigationDecision.prevent;
      },
    );
  }
}