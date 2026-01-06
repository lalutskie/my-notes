
import 'package:hive_firebase/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    required this.obSecureText,
    this.focusNode,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.isReadable, this.onSubmit, this.textInputAction, this.keyboardType,
  });

  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final bool obSecureText;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? isReadable;
  final void Function()? onSubmit;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscure;

  @override
  void initState() {
    _obscure = widget.obSecureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      autofocus: false,
      obscureText: _obscure,
      minLines: _obscure ? 1 : (widget.minLines ?? 1),
      maxLines: _obscure ? 1 : (widget.maxLines ?? 1),
      maxLength: widget.maxLength,
      readOnly: widget.isReadable ?? false,
      textAlignVertical: TextAlignVertical.top,
      enableInteractiveSelection: true,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onFieldSubmitted: (value) {
        if (widget.onSubmit != null) {
          widget.onSubmit!();
        }
      },
      decoration: InputDecoration(
        alignLabelWithHint: true,
        suffixIcon: widget.obSecureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off : Icons.visibility,
                  color: CustomTheme.colors(context).tertiaryText,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        isDense: false,
        labelText: widget.labelText,
        labelStyle: CustomTheme.typography(
          context,
        ).bodySmall.copyWith(color: CustomTheme.colors(context).tertiaryText),
        hintText: widget.hintText,
        hintStyle: CustomTheme.typography(
          context,
        ).bodySmall.copyWith(color: CustomTheme.colors(context).tertiaryText),
        errorStyle: CustomTheme.typography(
          context,
        ).bodySmall.copyWith(color: CustomTheme.colors(context).error),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomTheme.colors(context).primaryBackground,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomTheme.colors(context).primary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomTheme.colors(context).error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: CustomTheme.colors(context).error,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        filled: true,
        fillColor: CustomTheme.colors(context).secondaryBackground,
        contentPadding: EdgeInsets.all(16.0),
      ),
      style: CustomTheme.typography(
        context,
      ).bodyMedium.copyWith(color: CustomTheme.colors(context).primaryText),
      cursorColor: CustomTheme.colors(context).primaryText,
      // validator: (error) {
      //   return 'asdad';
      // },
    );
  }
}
