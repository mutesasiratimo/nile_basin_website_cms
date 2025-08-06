import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const kDuration = Duration(milliseconds: 600);

Future<void> openUrlLink(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> openPhoneDialer(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch phone dialer';
  }
}

Future<void> openEmailClient(String email) async {
  final Uri emailUri = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch email client';
  }
}

Future<void> openMapsNavigation() async {
  // You can customize this to open a specific location
  // For now, it will open Google Maps
  const String mapsUrl =
      'https://www.google.com/maps/place/Nile+Basin+International+School/@0.3842001,32.6117674,17z/data=!3m1!4b1!4m6!3m5!1s0x177db1a845f87511:0xe3d87845bc3c8f0c!8m2!3d0.3841947!4d32.6143477!16s%2Fg%2F11sjgq9137?entry=ttu&g_ep=EgoyMDI1MDgwMy4wIKXMDSoASAFQAw%3D%3D';
  final Uri mapsUri = Uri.parse(mapsUrl);
  if (await canLaunchUrl(mapsUri)) {
    await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch maps';
  }
}

Future<void> openWhatsApp(String phoneNumber) async {
  // Remove any spaces or special characters from phone number
  String cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
  final String whatsappUrl = 'https://wa.me/$cleanPhone';
  final Uri whatsappUri = Uri.parse(whatsappUrl);

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch WhatsApp';
  }
}

scrollToSection(BuildContext context) {
  Scrollable.ensureVisible(
    context,
    duration: kDuration,
  );
}
