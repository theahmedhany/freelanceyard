import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:single_screen_calculator_app/widgets/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> symbols = [
    'AC',
    '( )',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '−',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'Ans',
    '=',
  ];

  String input = '';
  String output = '';

  final List<String> operators = ['%', '÷', '×', '+', '−'];

  bool isLastCharOperator() {
    return operators.contains(input.isNotEmpty ? input[input.length - 1] : '');
  }

  bool hasUnclosedParenthesis() {
    return input.split('(').length > input.split(')').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB), // Background
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 10),
            const CustomAppBar(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Text(
                input,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6B7280), // Text Secondary
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                output,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w500,
                  color: output == 'Error.'
                      ? const Color(0xffDC2626) // Error red
                      : const Color(0xff1A202C), // Text Primary
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  if (input.isNotEmpty) {
                    setState(() {
                      input = input.substring(0, input.length - 1);
                    });
                  }
                },
                icon: const Icon(
                  Icons.backspace_outlined,
                  color: Color(0xff1A202C), // Text Primary
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: symbols.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onSymbolTap(symbols[index]),
                  child: InnerShadow(
                    shadows: [
                      Shadow(
                        color: const Color(0xffC53030).withOpacity(0.3),
                        blurRadius: 6,
                      ),
                    ],
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: buttonsBackgroundColor(symbols[index]),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        symbols[index],
                        style: TextStyle(
                          color: buttonsTextColor(symbols[index]),
                          fontSize:
                              (symbols[index] == 'Ans' ||
                                  symbols[index] == 'AC')
                              ? 24
                              : 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  void onSymbolTap(String symbol) {
    if (symbol == 'AC') {
      setState(() {
        input = '';
        output = '';
      });
    } else if (symbol == '( )') {
      setState(() {
        if (hasUnclosedParenthesis()) {
          input += ')';
        } else {
          input += '(';
        }
      });
    } else if (symbol == 'Ans') {
      setState(() {
        input = output.replaceAll("= ", "");
        output = '';
      });
    } else if (operators.contains(symbol)) {
      if (!isLastCharOperator()) {
        setState(() {
          input += symbol;
        });
      }
    } else if (symbol == '=') {
      try {
        String finalInput = input
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('−', '-');
        Expression exp = Parser().parse(finalInput);
        double result = exp.evaluate(EvaluationType.REAL, ContextModel());
        setState(() {
          if (result == result.toInt()) {
            output = "= ${result.toInt()}";
          } else {
            output = "= $result";
          }
        });
      } catch (e) {
        setState(() {
          output = 'Error.';
        });
      }
    } else {
      setState(() {
        input += symbol;
      });
    }
  }

  Color buttonsBackgroundColor(String symbol) {
    if (symbol == 'AC') {
      return const Color(0xffC53030); // Red Accent
    } else if (operators.contains(symbol) || symbol == '=' || symbol == '( )') {
      return const Color(0xffFEE2E2); // Light red for operators
    } else {
      return const Color(0xff1F2937); // Dark for numbers
    }
  }

  Color buttonsTextColor(String symbol) {
    if (symbol == 'AC') {
      return Colors.white; // White on red
    } else if (operators.contains(symbol) || symbol == '( )' || symbol == '=') {
      return const Color(0xff1A202C); // Dark red text
    } else {
      return Colors.white; // White for number buttons
    }
  }
}
