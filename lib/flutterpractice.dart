import 'package:flutter/material.dart';
import 'dart:ui';
void main() {
  runApp(const RestaurantApp());
}

class RestaurantApp extends StatelessWidget {
  const RestaurantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Menu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}

class FoodItem {
  final String image;
  final String name;
  final double price;

  const FoodItem({
    required this.image,
    required this.name,
    required this.price,
  });
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  final List<FoodItem> menu = const [
    FoodItem(image: 'images/burger.jpeg', name: 'Beef Burger', price: 899),
    FoodItem(image: 'images/pizza.jpeg', name: 'Margherita Pizza', price: 1250),
    FoodItem(image: 'images/pasta.jpeg', name: 'Creamy Pasta', price: 1075),
    FoodItem(image: 'images/salad.jpeg', name: 'Garden Salad', price: 650),
    FoodItem(image: 'images/fries.jpeg', name: 'Crispy Fries', price: 399),
    FoodItem(image: 'images/dessert.jpeg', name: 'Chocolate Cake', price: 525),
  ];

  void _order(BuildContext context, FoodItem item) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to your order!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Center(
            child: Container(
              width: 320,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Restaurant Menu',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: menu.map((item) => _buildFoodCard(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildFoodCard(BuildContext context, FoodItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tap image to enlarge using AnimatedCrossFade
            AnimatedFoodImage(imagePath: item.image),
            const SizedBox(width: 14),

            // Name and price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'PKR ${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Order button
            ElevatedButton(
              onPressed: () => _order(context, item),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Order'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A StatefulWidget that uses [AnimatedCrossFade] to smoothly animate
/// image enlargement/shrinkage when tapped.

class AnimatedFoodImage extends StatefulWidget {
  final String imagePath;

  const AnimatedFoodImage({
    super.key,
    required this.imagePath,
  });

  @override
  State<AnimatedFoodImage> createState() =>
      _AnimatedFoodImageState();
}

class _AnimatedFoodImageState extends State<AnimatedFoodImage> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 5000),
        curve: Curves.easeInOutCubic,
        width: _isExpanded ? 350 : 350,
        height: _isExpanded ? 350 : 350,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            _isExpanded ? 120 : 100,
          ),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.fastfood,
                  size: 50,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

