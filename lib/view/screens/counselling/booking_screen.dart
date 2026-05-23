import 'package:flutter/material.dart';
import 'package:supporthive1/model/expert_model.dart';
import 'package:supporthive1/service/razorpay_servie.dart';

class BookingScreen extends StatefulWidget {
  final Expert expert;

  const BookingScreen({super.key, required this.expert});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {

  String selectedType = "Video";
  String selectedDate = "";
  String selectedTime = "";

  final RazorpayService payment = RazorpayService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book Session")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // TYPE
            Row(
              children: [
                _chip("Audio"),
                _chip("Video"),
              ],
            ),

            const SizedBox(height: 10),

            // DATE
            Wrap(
              spacing: 8,
              children: ["Mon", "Tue", "Wed"].map((d) {
                return ChoiceChip(
                  label: Text(d),
                  selected: selectedDate == d,
                  onSelected: (_) => setState(() => selectedDate = d),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            // TIME
            Wrap(
              spacing: 8,
              children: ["10 AM", "2 PM", "6 PM"].map((t) {
                return ChoiceChip(
                  label: Text(t),
                  selected: selectedTime == t,
                  onSelected: (_) => setState(() => selectedTime = t),
                );
              }).toList(),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                payment.startPayment(widget.expert.price, widget.expert.name);
              },
              child: Text("Pay ₹${widget.expert.price}"),
            )
          ],
        ),
      ),
    );
  }

  Widget _chip(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(text),
        selected: selectedType == text,
        onSelected: (_) => setState(() => selectedType = text),
      ),
    );
  }
}