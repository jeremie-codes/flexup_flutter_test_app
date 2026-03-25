import 'package:flutter/material.dart';
import 'package:flexup_flutter/flexup_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TestFlexUpPage());
  }
}

class TestFlexUpPage extends StatefulWidget {
  const TestFlexUpPage({super.key});

  @override
  State<TestFlexUpPage> createState() => _TestFlexUpPageState();
}

class _TestFlexUpPageState extends State<TestFlexUpPage> {
  final FlexUpSDK sdk = FlexUpSDK();
  String statusMessage = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    sdk.init(
      config: FlexUpConfig(
        publicKey: 'pbk_test_123',
        secretKey: 'pvk_test_123',
        environment: 'dev',
      ),
    );

    sdk.onPaymentComplete((res) {
      setState(() {
        if (res.status == 'success') {
          statusMessage = 'Paiement réussi ! ID: ${res.transactionId}';
        } else if (res.status == 'cancel') {
          statusMessage = 'Paiement annulé';
        } else {
          statusMessage = 'Paiement échoué: ${res.message ?? 'inconnu'}';
        }
      });
    });
  }

  void startDeposit() async {
    print("PaymentView build");
    setState(() => _isLoading = true);
    try {
      await sdk.deposit(
        context,
        TopUpPayload(
          amount: 50,
          currency: 'USD',
          cardNumber: '4242424242424242',
          firstname: 'Jeremie',
          lastname: 'Mianda',
          middlename: 'Mbata',
          address: 'Avenue 154',
          country: 'CD',
          city: 'Kinshasa',
          description: 'Test dépôt',
          reference: 'REF-001',
        ),
      );
    } catch (e) {
      setState(() {
        print('Erreur dépôt: ${e.toString()})');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur dépôt: ${e.toString()})'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void startTransfer() async {
    setState(() => _isLoading = true);
    try {
      await sdk.transfer(
        context,
        TransferPayload(
          amount: 30,
          currency: 'USD',
          cardNumber: '4111111111111111',
          cardCvv: '123',
          expiryDate: '12/28',
          firstname: 'Jeremie',
          lastname: 'Mianda',
          middlename: 'Mbata',
          address: 'Avenue 154',
          country: 'CD',
          city: 'Kinshasa',
          description: 'Test transfert',
          reference: 'REF-002',
        ),
      );
    } catch (e) {
      setState(() {
        statusMessage = "Erreur dépôt: ${e.toString()}";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur dépôt: ${e.toString()})'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Modal Sheet')),
      body: Center(
        child: Column(
          children: [
            Text(statusMessage),
            if (_isLoading) const CircularProgressIndicator(),
            ElevatedButton(
              onPressed: startDeposit,
              child: const Text('Deposer'),
            ),
            ElevatedButton(
              onPressed: startTransfer,
              child: const Text('Transfert'),
            ),
          ],
        ),
      ),
    );
  }
}
