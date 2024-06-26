import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        _buildProductContainer(
          name: 'Jolene Top',
          description: 'Material : 100% Premium Cotton\nAvailable in Blue, White, Black\nSize Chart : S-L',
          price: '\Rp 150.000,00',
          imagePath: 'assets/product 1.png',
        ),
        SizedBox(height: 16.0),
        _buildProductContainer(
          name: 'Ariel Dress',
          description: 'Material : 100% Premium Cotton\nAvailable in Black, White, Pink, Maroon\nSize Chart : S-M',
          price: '\Rp 250.000,00',
          imagePath: 'assets/product 2.png',
        ),
        SizedBox(height: 16.0),
        _buildProductContainer(
          name: 'Bora Shorts',
          description: 'Material : 100% Linen\nAvailable in Baby Pink, Tosca, Khaki, White\nSize Chart : S-L',
          price: '\Rp 100.000,00',
          imagePath: 'assets/product 3.png',
        ),
         SizedBox(height: 16.0),
        _buildProductContainer(
          name: 'Cassie Dress',
          description: 'Material : 100% Premium Cotton\nAvailable in Beige, Black, Blue\nSize Chart : S-XL',
          price: '\Rp 200.000,00',
          imagePath: 'assets/product 4.png',
        ),
      ],
    );
  }

  Widget _buildProductContainer({
    required String name,
    required String description,
    required String price,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 150, 
              height: 150,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                      style: GoogleFonts.lexend(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                      description,
                      style: GoogleFonts.cabin(
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: $price',
                      style: GoogleFonts.lexend(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}