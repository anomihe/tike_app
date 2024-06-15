abstract class DownloaderState {}

class IntialState extends DownloaderState {}

class DownloadingState extends DownloaderState {}

class DownloadInProgress extends DownloaderState {
  int progress = 0;
  DownloadInProgress(progress);
}

class DownloadingComplete extends DownloaderState {
  final String text;
  DownloadingComplete(this.text);
}

class DownloadFailed extends DownloaderState {
  // final String error;
  // DownloadFailed(this.error);
}
