import 'package:flutter/material.dart';

class BouncingPopup extends StatefulWidget {
  final String? editTitle;

  BouncingPopup({this.editTitle});
  @override
  _BouncingPopupState createState() => _BouncingPopupState();
}

class _BouncingPopupState extends State<BouncingPopup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  TextEditingController _textController = TextEditingController();

  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );
    _controller.forward();
    if (widget.editTitle != null) {
      _textController.text = widget.editTitle!;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: AlertDialog(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          // side: BorderSde(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(24),
        ),
        content: Container(
          width: 300,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _textController,
                onChanged: (value) => _textController.text = value,
                onSubmitted: (value) => _textController.text = value,
                decoration: InputDecoration(
                  hintText: 'Add Category...',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none, // Removes the default border side (for flat design)
                  ),
                  errorText: _showError ? 'Category name cannot be empty !' : null,
                  errorStyle: TextStyle(
                    fontSize: 13,
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                  onPressed: () {
                    if (_textController.text.trim().isEmpty) {
                      setState(() {
                        _showError = true;
                      });
                    } else {
                      setState(() {
                        _showError = false;
                      });
                      if (widget.editTitle != null) {
                        _textController.text == widget.editTitle
                            ? Navigator.of(context).pop()
                            : Navigator.of(context).pop(_textController.text);
                      } else {
                        Navigator.of(context).pop(_textController.text);
                      }
                    }
                  },
                  child:
                      Container(margin: EdgeInsets.all(15), child: Text(widget.editTitle != null ? 'UPDATE' : 'ADD')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
