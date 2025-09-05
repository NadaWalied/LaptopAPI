import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class Api extends StatelessWidget {
  const Api({super.key});

  Future<List<dynamic>> getData() async {
    final Dio dio = Dio();
    var response =
    await dio.get("https://elwekala.onrender.com/product/Laptops");

    debugPrint("API RESPONSE: ${response.data}");

    if (response.data is Map && response.data["product"] != null) {
      return response.data["product"];
    }

    throw Exception("Unexpected API response format: ${response.data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (snapshot.hasData) {
            var list = snapshot.data!;
            if (list.isEmpty) {
              return const Center(child: Text("No products found."));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final product = list[index];
                final List images = product["images"] ?? [];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // صورة المنتج
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: images.isNotEmpty
                                  ? Image.network(
                                images[0],
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              )
                                  : const Icon(
                                Icons.image_not_supported,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Name:${product["name"] ?? "N/A"}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),
                          Text(
                            "Status: ${product["status"] ?? "Unknown"}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            "Category: ${product["category"] ?? "N/A"}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Text(
                            "Company: ${product["company"] ?? "N/A"}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Price: \$${product["price"] ?? "N/A"}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            product["description"] ?? "No description",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,

                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}


