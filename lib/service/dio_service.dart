import 'package:dio/dio.dart';
import 'package:extractor/extractor.dart';
import 'package:direct_link/direct_link.dart';
import 'package:path/path.dart' as path;

class DioServices {
  final Dio dio = Dio();
  var directLink = DirectLink();

  Future<void> downloadVideo(
      String url, String savedDir, String fileName) async {
    String filePath = path.join(savedDir, fileName);
    try {
      await dio.download(url, filePath, onReceiveProgress: (rec, total) {
        print("Rec: $rec , Total: $total");
      });
      print('downloaded');
    } catch (e) {
      print(e);
    }
  }

  void getData(String url) async {
//  var results =  Extractor.getDirectLink(link: 'https://www.youtube.com/watch?v=Ne7y9_AbBsY');
    //VideoData? results =await Extractor.getDirectLink(link: 'https://www.youtube.com/watch?v=Ne7y9_AbBsY', timeout: 10);
    print('this is url $url');
    var results = await directLink.check(url, timeout: Duration(seconds: 10));
   var links = results?.links
          ?.map((link) => {
                'quality': link.quality,
                'type': link.type,
                'link': link.link,
              })
          .toList();
    print(' this is my result $results ${links}');
  }
}

// class VideoData {
//   bool? status;
//   String? message;
//   String? title;
//   String? thumbnail;
//   String? duration;
//   List<Link>? links;

//   VideoData({
//     this.status,
//     this.message,
//     this.title,
//     this.thumbnail,
//     this.duration,
//     this.links,
//   });

//   factory VideoData.fromJson(Map<String, dynamic> json) {
//     var linksJson = json['links'] as List<dynamic>?;
//     List<Link>? linksList = linksJson?.map((linkJson) => Link.fromJson(linkJson as Map<String, dynamic>)).toList();

//     return VideoData(
//       status: json['status'] as bool?,
//       message: json['message'] as String?,
//       title: json['title'] as String?,
//       thumbnail: json['thumbnail'] as String?,
//       duration: json['duration'] as String?,
//       links: linksList,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     var linksList = links?.map((link) => link.toJson()).toList();

//     return {
//       'status': status,
//       'message': message,
//       'title': title,
//       'thumbnail': thumbnail,
//       'duration': duration,
//       'links': linksList,
//     };
//   }
// }
