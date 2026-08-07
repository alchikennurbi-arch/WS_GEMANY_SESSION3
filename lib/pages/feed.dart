import 'package:flutter/material.dart';
import 'package:session3/api/api_service.dart';
import 'package:share_plus/share_plus.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final ApiService _apiService = ApiService();
  List<dynamic> posts = [];
  bool isloading = true;
  int currentUserId = 1;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      final fetchedPosts = await ApiService.posts();

      final filteredPosts =
          fetchedPosts
              .where((post) => post["author"]["id"] != currentUserId)
              .toList()
            ..sort(
              (a, b) => DateTime.parse(
                b["createdAt"],
              ).compareTo(DateTime.parse(a["createdAt"])),
            );

      if (mounted) {
        setState(() {
          posts = filteredPosts;
          isloading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  Future<void> _toggleLike(int index) async {
    final post = posts[index];
    final bool isLiked = (post["likedBy"] as List).any(
      (u) => u["id"] == currentUserId,
    );

    setState(() {
      if (isLiked) {
        post["likedBy"].removeWhere((e) => e["id"] == currentUserId);
      } else {
        post["likedBy"].add({"id": currentUserId});
      }
    });

    if (isLiked) {
      await ApiService.deleate(post["id"]);
    } else {
      await ApiService.likes(post["id"]);
    }
  }

  void showCommentsList(int postId, List comments) {
    final TextEditingController textEditingController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SizedBox(
                height: 400,
                child: Column(
                  children: [
                    const Text(
                      "Comments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: comments.isEmpty
                          ? const Center(child: Text("No comments yet"))
                          : ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final c = comments[index];
                                final author = c["author"] as Map;
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: author["imageUrl"] != null
                                        ? NetworkImage(
                                            "${ApiService.getUri}${author["imageUrl"]}",
                                          )
                                        : null,
                                    child: author["imageUrl"] == null
                                        ? Text(
                                            author["username"][0].toUpperCase(),
                                          )
                                        : null,
                                  ),
                                  title: Text(author["username"]),
                                  subtitle: Text(c["text"]),
                                );
                              },
                            ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: textEditingController,
                            decoration: const InputDecoration(
                              hintText: "Add a comment...",
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (textEditingController.text.trim().isNotEmpty) {
                              final newcomment = await ApiService.comments(
                                postId,
                                textEditingController.text.trim(),
                              );

                              setModalState(() {
                                comments.add(newcomment);
                              });
                              textEditingController
                                  .clear(); // comments.clear() өшірілді
                            }
                          },
                          icon: const Icon(Icons.send, color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void sharePosts(Map<String, dynamic> post) {
    final String caption = post["caption"] ?? "";
    final String authorName = post["author"]["username"] ?? "";
    Share.share("$caption\n\nPosted By: $authorName");
  }

  @override
  Widget build(BuildContext context) {
    if (isloading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("Feed Page"),
      ),
      body: RefreshIndicator(
        onRefresh: loadPosts,
        child: ListView.builder(
          itemCount: posts.length, // ТҮЗЕТІЛДІ: Элемент саны қосылды
          itemBuilder: (context, index) {
            final post = posts[index];
            final author = post["author"];
            final bool isLiked = (post["likedBy"] as List).any(
              (e) => e["id"] == currentUserId,
            );

            return Card(
              margin: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Author Info
                  ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "profile",
                          arguments: author["id"],
                        );
                      },
                      child: CircleAvatar(
                        backgroundImage: author["imageUrl"] != null
                            ? NetworkImage(
                                "${ApiService.getUri}${author["imageUrl"]}",
                              )
                            : null,
                        child: author["imageUrl"] == null
                            ? Text(author["username"][0].toUpperCase())
                            : null,
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "profile",
                          arguments: author["id"],
                        );
                      },
                      child: Text(
                        author["username"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  // 2. Image & Stickers Stack
                  // 2. Image & Stickers Stack
                  if (post['imageUrl'] != null &&
                      post['imageUrl'].toString().isNotEmpty)
                    Stack(
                      children: [
                        Image.network(
                          "${ApiService.getUri}${post["imageUrl"]}",
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                        ...?((post["stickers"] as List?)?.map((sticker) {
                          final stickerUrl = sticker["imageUrl"];
                          if (stickerUrl == null ||
                              stickerUrl.toString().isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return Positioned(
                            left:
                                double.tryParse(
                                  sticker["x"]?.toString() ?? '',
                                ) ??
                                50.0,
                            top:
                                double.tryParse(
                                  sticker["y"]?.toString() ?? '',
                                ) ??
                                40.0,
                            child: Image.network(
                              "${ApiService.getUri}$stickerUrl",
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                          );
                        })),
                      ],
                    ),

                  // 3. Action Buttons (Row)
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _toggleLike(index),
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                      ),
                      Text("${(post["likedBy"] as List).length}"),
                      IconButton(
                        onPressed: () =>
                            showCommentsList(post["id"], post["comments"]),
                        icon: const Icon(Icons.mode_comment_outlined),
                      ),
                      Text("${(post["comments"].length)}"),
                      const Spacer(),
                      IconButton(
                        onPressed: () => sharePosts(post),
                        icon: const Icon(Icons.share),
                      ),
                    ],
                  ),

                  // 4. Caption
                  if (post["caption"] != null &&
                      post["caption"].toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: "${author["username"]} ",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: post["caption"]),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
