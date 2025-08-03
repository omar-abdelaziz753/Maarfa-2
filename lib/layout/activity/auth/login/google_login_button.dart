// Add this widget to your widgets folder
// File: widget/buttons/google_login/google_login_button.dart
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:my_academy/res/value/style/textstyles.dart';
import 'package:my_academy/widget/side_padding/side_padding.dart';

class GoogleLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double sidePadding;
  final bool isLoading;

  const GoogleLoginButton({
    super.key,
    required this.onPressed,
    this.sidePadding = 15,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: sidePadding,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    )
                  else ...[
                    // Google Logo SVG (you can replace with your own asset)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://developers.google.com/identity/images/g-logo.png',
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      tr("continue_with_google"),
                      style: TextStyles.appBarStyle.copyWith(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Alternative design with custom Google icon
class GoogleLoginButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final double sidePadding;
  final bool isLoading;

  const GoogleLoginButtonCustom({
    super.key,
    required this.onPressed,
    this.sidePadding = 15,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SidePadding(
      sidePadding: sidePadding,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    )
                  else ...[
                    // Custom Google G icon
                    Container(
                      width: 22,
                      height: 22,
                      child: CustomPaint(
                        painter: GoogleLogoPainter(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      tr("sign_in_with_google"),
                      style: TextStyles.appBarStyle.copyWith(
                        color: const Color(0xFF1f1f1f),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for Google logo
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Blue
    paint.color = const Color(0xFF4285F4);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width, size.height * 0.5)
        ..lineTo(size.width, size.height * 0.75)
        ..arcToPoint(
          Offset(size.width * 0.5, size.height),
          radius: Radius.circular(size.width * 0.25),
        )
        ..close(),
      paint,
    );

    // Green
    paint.color = const Color(0xFF34A853);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width * 0.5, size.height)
        ..arcToPoint(
          Offset(0, size.height * 0.75),
          radius: Radius.circular(size.width * 0.25),
          clockwise: false,
        )
        ..lineTo(0, size.height * 0.25)
        ..arcToPoint(
          Offset(size.width * 0.25, 0),
          radius: Radius.circular(size.width * 0.25),
          clockwise: false,
        )
        ..lineTo(size.width * 0.5, 0)
        ..close(),
      paint,
    );

    // Yellow
    paint.color = const Color(0xFFFBBC05);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width * 0.5, 0)
        ..lineTo(size.width * 0.75, 0)
        ..arcToPoint(
          Offset(size.width, size.height * 0.25),
          radius: Radius.circular(size.width * 0.25),
        )
        ..lineTo(size.width, size.height * 0.5)
        ..close(),
      paint,
    );

    // Red
    paint.color = const Color(0xFFEA4335);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.5, size.height * 0.5)
        ..lineTo(size.width, size.height * 0.5)
        ..lineTo(size.width, size.height * 0.25)
        ..arcToPoint(
          Offset(size.width * 0.75, 0),
          radius: Radius.circular(size.width * 0.25),
          clockwise: false,
        )
        ..lineTo(size.width * 0.25, 0)
        ..arcToPoint(
          Offset(0, size.height * 0.25),
          radius: Radius.circular(size.width * 0.25),
        )
        ..lineTo(0, size.height * 0.75)
        ..arcToPoint(
          Offset(size.width * 0.5, size.height),
          radius: Radius.circular(size.width * 0.25),
          clockwise: false,
        )
        ..close(),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}