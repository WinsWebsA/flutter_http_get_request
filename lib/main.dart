import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_http_client/post_model.dart';
import 'package:http/http.dart' as http;

void main() {
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final uri = 'https://jsonplaceholder.typicode.com/posts';

  // Using flutter HTTP client
  Future<List<PostModel>> getPost() {
    try {
      return HttpClient()
          .getUrl(Uri.parse(uri))
          .then((req) => req.close())
          .then((resp) => resp.transform(utf8.decoder).join())
          .then((str) => json.decode(str) as List<dynamic>)
          .then((list) => list.map((e) => PostModel.fromJson(e)).toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

// Using flutter HTTP package
  Future<List<PostModel>> getData() async {
    try {
      var res = await http.get(Uri.parse(uri));
      var jsonData = jsonDecode(res.body) as List<dynamic>;
      return jsonData.map((e) => PostModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HTTP Connection"),
        backgroundColor: Colors.greenAccent,
      ),
      body: FutureBuilder<List<PostModel>>(
        future: getData(),
        /* getPost() */
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var myPost = snapshot.data!;

            return ListView.builder(
              itemCount: myPost.length,
              itemBuilder: (context, index) {
                var post = myPost[index];

                return Card(
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
