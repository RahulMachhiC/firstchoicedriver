extension StringExtension on String {
  bool get isNetworkUrl {
    return contains('http');
  }

  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool get isVideo {
    var path = toLowerCase();
    return path.contains('.mp4') ||
        path.contains('.avi') ||
        path.contains('.mov') ||
        path.contains('.mkv') ||
        path.contains('.webm');
  }

  String get inCaps {
    if (isEmpty) {
      return '';
    }

    if (length < 2) {
      return this[0].toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get capitalizeFirstOfEach {
    if (isEmpty) {
      return '';
    }
    return toLowerCase().split(' ').map((str) => str.inCaps).join(' ');
  }

  String getFileWithFileExtension(String filePath) {
    try {
      return '$this.${filePath.split('.').last}';
    } catch (e) {
      return this;
    }
  }
}
