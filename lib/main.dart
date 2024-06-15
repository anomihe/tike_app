import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:tiktok_downloader/bloc/bloc_events.dart';
import 'package:tiktok_downloader/bloc/bloc_state.dart';
import 'package:tiktok_downloader/bloc/main_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
          create: (context) => MainBloc(),
          child: const MyHomePage(title: 'Video Downloader')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Enter the URL link ',
              ),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter a valid link';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<MainBloc, DownloaderState>(builder: (context, state) {
                if (state is IntialState) {
                  return const Text('Press the button to start downloading');
                } else if (state is DownloadInProgress) {
                  return Text('Download progress: ${state.progress}%');
                } else if (state is DownloadingComplete) {
                  return Text('Download complete! ${state.text}');
                }else if (state is DownloadingComplete) {
                  return  Text('Enter another link ${state.text} %');
                } 
                else if (state is DownloadFailed) {
                  return const Text('Download failed.');
                }
                return Container();
              }),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<MainBloc>(context).add(EnterLink(
                      controller.text,
                    ));
                  }
                  controller.clear();
                },
                child: Container(
                  child: Text('Download'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
