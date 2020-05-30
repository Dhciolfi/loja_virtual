import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/screens/edit_product/components/image_source_sheet.dart';

class ImagesForm extends StatelessWidget {

  const ImagesForm(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<dynamic>>(
      initialValue: product.images,
      validator: (images){
        if(images.isEmpty)
          return 'Insira ao menos uma imagem';
        return null;
      },
      builder: (state){
        void onImageSelected(File file){
          state.value.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: state.value.map<Widget>((image){
                  return Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      if(image is String)
                        Image.network(image, fit: BoxFit.cover,)
                      else
                        Image.file(image as File, fit: BoxFit.cover,),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.remove),
                          color: Colors.red,
                          onPressed: (){
                            state.value.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      )
                    ],
                  );
                }).toList()..add(
                  Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: Icon(Icons.add_a_photo),
                      color: Theme.of(context).primaryColor,
                      iconSize: 50,
                      onPressed: (){
                        if(Platform.isAndroid)
                          showModalBottomSheet(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              )
                          );
                        else
                          showCupertinoModalPopup(
                              context: context,
                              builder: (_) => ImageSourceSheet(
                                onImageSelected: onImageSelected,
                              )
                          );
                      },
                    ),
                  )
                ),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: Theme.of(context).primaryColor,
                autoplay: false,
              ),
            ),
            if(state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 16, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
