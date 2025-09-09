import 'package:flutter/material.dart';
import 'neuromorphic_theme.dart';

class NeuCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final bool isPressed;

  const NeuCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
    this.onTap,
    this.isPressed = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final responsivePadding =
          isMobile ? const EdgeInsets.all(12) : padding;
      final responsiveMargin =
          isMobile ? const EdgeInsets.all(4) : margin;

      return Container(
        width: width,
        height: height,
        margin: responsiveMargin,
        decoration:
            isPressed ? NeuBoxDecoration.pressed : NeuBoxDecoration.elevated,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: responsivePadding,
              child: child,
            ),
          ),
        ),
      );
    });
  }
}

class NeuButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? textColor;

  const NeuButton({
    super.key,
    required this.child,
    this.onPressed,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.margin = const EdgeInsets.all(4),
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final responsivePadding = isMobile
          ? const EdgeInsets.symmetric(vertical: 12, horizontal: 20)
          : widget.padding;

      return GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: widget.width,
          height: widget.height,
          margin: widget.margin,
          padding: responsivePadding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? NeuromorphicTheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed
                ? [
                    const BoxShadow(
                      color: NeuromorphicTheme.shadowDark,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: NeuromorphicTheme.shadowLight,
                      offset: Offset(-4, -4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                    const BoxShadow(
                      color: NeuromorphicTheme.shadowDark,
                      offset: Offset(4, 4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: widget.textColor ?? Colors.white,
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
              child: widget.child,
            ),
          ),
        ),
      );
    });
  }
}

class NeuTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;

  const NeuTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final contentPadding = isMobile
          ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 16);

      return Container(
        decoration: BoxDecoration(
          color: NeuromorphicTheme.cardBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: NeuromorphicTheme.shadowDark,
              offset: Offset(2, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: NeuromorphicTheme.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: contentPadding,
            labelStyle: const TextStyle(color: NeuromorphicTheme.textSecondary),
            hintStyle: const TextStyle(color: NeuromorphicTheme.textLight),
          ),
          style: TextStyle(
            color: NeuromorphicTheme.text,
            fontSize: isMobile ? 14 : 16,
          ),
        ),
      );
    });
  }
}

class NeuContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const NeuContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: NeuBoxDecoration.elevated,
      child: child,
    );
  }
}

class NeuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const NeuAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;
      final titleFontSize = isMobile ? 18.0 : 20.0;

      return Container(
        decoration: const BoxDecoration(
          color: NeuromorphicTheme.background,
          boxShadow: [
            BoxShadow(
              color: NeuromorphicTheme.shadowDark,
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: AppBar(
          title: Text(
            title,
            style: TextStyle(
              color: NeuromorphicTheme.primary,
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: NeuromorphicTheme.primary),
          actions: actions,
          leading: leading,
          automaticallyImplyLeading: automaticallyImplyLeading,
        ),
      );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
