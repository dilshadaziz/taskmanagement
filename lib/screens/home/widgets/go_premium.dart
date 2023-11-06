import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Widget to prompt users to subscribe to a premium service.
class GoPremium extends StatelessWidget {
  const GoPremium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Container for the premium feature
        Container(
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Circular container with a star icon
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
              const SizedBox(width: 15.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title: "Go Premium"
                  const Text(
                    'Go Premium',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  // Description of premium features
                  Text(
                    'Get unlimited access \nto all our features!',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15.0,
          right: 15.0,
          child: GestureDetector(
            onTap: () {
              // Show an AlertDialog when the arrow button is tapped
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Title of the AlertDialog
                    title: const Text(
                      'Premium',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Content of the AlertDialog
                    content: const Text(
                      'Our Premium services are not available right now. We\'ll notify you when it is available. Sorry for the inconvenience caused.',
                    ),
                    actions: <Widget>[
                      // Close button
                      TextButton(
                        onPressed: () {
                          // Close the AlertDialog
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ).animate().scaleX(
                        duration: const Duration(milliseconds: 400),
                      ),
                    ],
                  ).animate().shake();
                },
              );
            },
            child: Container(
              // Arrow button for going premium
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
