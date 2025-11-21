import 'package:flutter/material.dart';
void main() => runApp(const ArchDemo()); 
class ArchDemo extends StatefulWidget { 
  const ArchDemo({super.key}); 
  @override 
  State<ArchDemo> createState() => _ArchDemoState(); 
} 
class _ArchDemoState extends State<ArchDemo> { 
  int counter = 0; 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      // home: Profile(),
      home: Scaffold( 
        appBar: AppBar(title: const Text('Lab 2 — Architecture')), 
        body: Center( 
          child: Column( 
            mainAxisSize: MainAxisSize.min, 
            children: [ 
              Text('Counter: \$counter', style: const TextStyle(fontSize: 22)), 
              const SizedBox(height: 12), 
              ElevatedButton( 
                onPressed: () => setState(() => counter++), 
                child: const Text('Increment'), 
              ) 
            ], 
          ), 
        ), 
      ), 
); 
} 
}