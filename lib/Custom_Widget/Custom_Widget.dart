import "package:flutter/material.dart";

class UiHelper
{
  static customAppBar(String text) {
    return AppBar(
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
    );
  }
}