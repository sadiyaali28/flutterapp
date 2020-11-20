import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sample_app/gmap.dart';
import 'package:sample_app/stations.dart';


void main()
{
  runApp(myApp());
}
    
    class myApp extends StatelessWidget {
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Homepage",
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: MyHomePage(),
        );
      }
    }
    
    
  class MyHomePage extends StatefulWidget {
    @override
    _MyHomePageState createState() => _MyHomePageState();
  }
  
  class _MyHomePageState extends State<MyHomePage> {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.asset('assets/images/img1.jpg',
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                 children: <Widget>[
                    Container(
                      height: 200.0,
                      width: 450.0,
                      decoration: BoxDecoration(
                          color: Color(0xFFE8EAF6).withOpacity(0.3),
                          
                        
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Find charging stations for your Electric Vehicle at the touch of a button",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                               RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                
                                 onPressed: () => Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => GMap()),
                                 )
                                   
                                 , 
                                 color: Colors.indigo,

                                 child: Text(
                                   "Find!",
                                   style: TextStyle(
                                     fontSize: 24.0,
                                     color: Colors.white,

                                   ),
                                 )
                               )
                            ]
                          )
                        ]
                      ),
                    )

                 ]

                )
              ]
            )
          ]
        ),
      );
    }
  }

