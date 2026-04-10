import 'package:flutter/material.dart';
import 'package:flexup_flutter/flexup_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

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
  String? paymentUrl;
  bool _isLoading = false;
  Color primay_color = Color(0xFFf0776f);

  List<Map<String, dynamic>> cartes = [
    {
      'id': 1,
      'balance': '1,000',
      'cardNumber': '4242424242424242',
      'expiryDate': '12/25',
      'cvv': '123',
      'currency': 'USD',
    },
    {
      'id': 2,
      'balance': '100.000',
      'cardNumber': '4242424242424243',
      'expiryDate': '12/25',
      'cvv': '425',
      'currency': 'CDF',
    },
    {
      'id': 3,
      'balance': '400',
      'cardNumber': '4242424242424244',
      'expiryDate': '12/25',
      'cvv': '253',
      'currency': 'USD',
    },
  ];

  int _currentIndex = 0;
  int _currentPageIndex = 0;
  String _actionButtonKey = 'transfer';

  @override
  void initState() {
    super.initState();

    sdk.init(
      config: FlexUpConfig(
        apiKey: 'api_test_123',
        appId: 'com_test_123',
        environment: 'dev',
      ),
    );

    sdk.onPaymentComplete((res) {
      if (!mounted) return; // ← Vérifie d'abord

      setState(() {
        if (res.status == 'success') {
          statusMessage = 'Paiement réussi ! ID: ${res.transactionId}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Paiement réussi !'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else if (res.status == 'cancel') {
          statusMessage = 'Paiement annulé';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Paiement annulé !'),
              backgroundColor: Colors.orangeAccent,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        } else {
          statusMessage = 'Paiement échoué: ${res.message ?? 'inconnu'}';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(res.message ?? 'Paiement échoué !'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      });
    });
  }

  void startDeposit() async {
    setState(() => _isLoading = true);
    try {
      await sdk.deposit(
        context,
        TopUpPayload(
          amount: 1,
          currency: 'USD',
          pan: '4242424242424242',
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur dépôt: ${e.toString()})'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
          amount: 2,
          currency: 'USD',
          pan: '4111111111111111',
          cvv: '123',
          expMonth: "12",
          expYear: "2028",
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
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur dépôt: ${e.toString()})'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF161f26), Color(0xFF090F15)],
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                header(),
                SizedBox(height: 10),
                banner(),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                  child: Column(
                    children: [
                      actions(),
                      SizedBox(height: 20),
                      transactionList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primay_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () {
            if (_isLoading) return;

            if (_isLoading) return;
            setState(() {
              _actionButtonKey = "deposit_2";
            });
            startDeposit();
          },
          child: _isLoading && _actionButtonKey == "deposit_2"
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        backgroundColor: Colors.transparent,
        bottomNavigationBar: AnimatedBottomNavigationBar(
          icons: [
            Icons.home,
            Icons.person,
            Icons.notifications,
            Icons.settings,
          ],
          activeIndex: _currentPageIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          leftCornerRadius: 32,
          rightCornerRadius: 32,
          onTap: (index) => setState(() => _currentPageIndex = index),
          inactiveColor: Colors.white,
          activeColor: Colors.white,
          backgroundColor: Color(0xFF161f26),
        ),
      ),
    );
  }

  Widget header() {
    return Container(
      margin: EdgeInsets.only(top: 50, left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Salut Mianda",
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Bienvenue à nouveau!",
                textAlign: TextAlign.left,
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFC2C2C2),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.asset("images/avatar-5.jpg"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget banner() {
    return Center(
      child: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 220.0, // un peu réduit pour éviter overflow
              initialPage: 0,
              enlargeCenterPage: true,
              enlargeFactor: 0.25,
              onPageChanged: (value, _) {
                setState(() {
                  _currentIndex = value;
                });
              },
            ),
            items: cartes.map((carte) {
              return Builder(
                builder: (BuildContext context) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'images/banner.png',
                        height: 220,
                        fit: BoxFit.contain,
                      ),

                      Positioned(
                        top: 45,
                        left: 35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${carte['currency']} ${carte['balance']}",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 26,
                              ),
                            ),
                            Text(
                              'Total Balance',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 50),
                            Text(
                              'Jeremie Mianda',
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 50,
                        right: 25,
                        child: Text(
                          "${carte['expiryDate']}",
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          buildCoarouselIndicator(),
        ],
      ),
    );
  }

  Widget buildCoarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < cartes.length; i++)
          Container(
            margin: const EdgeInsets.all(5),
            height: i == _currentIndex ? 8 : 5,
            width: i == _currentIndex ? 8 : 5,
            decoration: BoxDecoration(
              color: i == _currentIndex ? primay_color : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  Widget actions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _isLoading && _actionButtonKey == "deposit"
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Color(
                          0xFF222D36,
                        ).withOpacity(0.5), // Couleur de fond transparente
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222D36),
                        padding: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: primay_color),
                        ),
                      ),
                      onPressed: () {
                        if (_isLoading) return;
                        setState(() {
                          _actionButtonKey = "deposit";
                        });
                        startDeposit();
                      },
                      icon: Icon(
                        Icons.account_balance_wallet_sharp,
                        color: Colors.blueGrey,
                      ),
                      label: Text(
                        'Recharger',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _isLoading && _actionButtonKey == "transfer"
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Color(
                          0xFF222D36,
                        ).withOpacity(0.5), // Couleur de fond transparente
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : ElevatedButton.icon(
                      key: Key(_actionButtonKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222D36),
                        padding: const EdgeInsets.all(30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_isLoading) return;
                        setState(() {
                          _actionButtonKey = "transfer";
                        });
                        startTransfer();
                      },
                      icon: Icon(
                        Icons.trending_up_outlined,
                        color: Colors.blueGrey,
                      ),
                      label: Text(
                        'Virement',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget transactionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dernières Transactions',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        for (var transaction in [1, 2, 3])
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromARGB(255, 31, 46, 57),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3640),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.monetization_on_sharp, color: primay_color),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UI/UX Course',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '28 Mars, 2022',
                        style: GoogleFonts.montserrat(
                          color: const Color(0xFFC2C2C2),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  '\$50.00',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
