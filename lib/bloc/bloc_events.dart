abstract class Downloader {}

class EnterLink implements Downloader {
  String link;
  EnterLink(this.link);
}

class CancelEvent implements Downloader {}

class UpdateDownloadProgress extends Downloader {
  final int progress;

  UpdateDownloadProgress(this.progress);

  // @override
  // List<Object?> get props => [progress];
}

class DownloadComplete extends Downloader {
  final int progress;

  DownloadComplete(this.progress);

  // @override
  // List<Object?> get props => [progress];
}

