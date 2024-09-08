import 'package:flutter/material.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({Key? key}) : super(key: key);

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  final List<Map<String, dynamic>> _allUsers = [
    {
      "image":
      "https://5.imimg.com/data5/AL/SG/EA/SELLER-86610723/oscar-24xl23-24-inch-500x500.jpg",
      "id": 1,
      "name": "Television",
      "des": "OnePlus 108 cm (43 inches) Y Series 4K Ultra",
    },
    {
      "id": 2,
      "name": "Air Conditioner",
      "des": "Chroma 4 in 1 Convertible 1 Ton 3 Star",
      "image":
      "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcQQJ3OncabMxucx6ZinjG8eaL5rcAogWzSLJURouhSdzijAKOZ_IxSG2i6Fl1VN5-4WZuhJkxyeaTCuEa0yLstYGLpIOTbXJw69NsuTdx_NS1xLQCKKZRbBzw",
    },
    {
      "id": 3,
      "name": "Speaker",
      "des": "boAt Stone 1000 14W Bluetooth Speaker",
      "image":
      "https://m.media-amazon.com/images/I/51CI0HFZi+L._SY300_SX300_.jpg",
    },
    {
      "id": 4,
      "name": "Smart Watch",
      "des": "Galaxy Watch4 Classic Bluetooth (46mm)",
      "image":
      "https://www.gonoise.com/cdn/shop/files/Carousel-500x500-1_9528c128-8fbf-4b80-afb4-66553d7c907a.png?v=1687523902",
    },
    {
      "id": 5,
      "name": "Refrigerator",
      "des": "Godrej 564 L Side-By-Side Refrigerator",
      "image":
      "https://m.media-amazon.com/images/I/51Prm9UO5EL._SY741_.jpg",
    },
    {
      "id": 6,
      "name": "Smart Phone",
      "des": "Apple iPhone 14 (128 GB) - Blue",
      "image":
      "https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/iphone-14-model-unselect-gallery-1-202209?wid=5120&hei=2880&fmt=p-jpg&qlt=80&.v=1660689596976",
    },
  ];

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _allUsers;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Search'),
      ),
      //Search Bar Code Start
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              // onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search),
                // prefix: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
            // Search Bar Code Close
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) => Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                      NetworkImage(_foundUsers[index]['image']),
                      backgroundColor: Colors.transparent,
                    ),
                    title: Text(_foundUsers[index]['name']),
                    subtitle: Text('${_foundUsers[index]["des"]}'),
                  ),
                ),
              )
                  : const Text(
                'No results found Please try with different search',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
