import 'dart:html';

/// 共有を行う。
///
/// 使える場合は navigator.share() を使い、
/// 使えない場合はTwitterのツイート用リンクを踏ませる。
Future<bool> share(String url, String title) async {
  try {
    //  本来はnavigator.shareがundefinedかどうかで有効性を判定すべき。
    final shareData = {'url': url, 'title': title};
    await window.navigator.share(shareData);

    return true;
  } catch (e) {
    //  何かしらの例外が発生したら未対応とみなし、
    //  Twitterでの共有にフォールバックする。
    final twitterUrl = 'https://twitter.com/intent/tweet?text='
        '${Uri.encodeQueryComponent(title)} - ${Uri.encodeQueryComponent(url)}';
    window.open(twitterUrl, '_blank');

    return false;
  }
}

/// 現在のページを共有する。
Future<bool> shareCurrentPage(String title) =>
    share(window.location.href, title);
