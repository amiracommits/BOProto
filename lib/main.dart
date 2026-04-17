import 'package:flutter/material.dart';
import 'dart:math';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';

class TransferData {
  final String cuentaOrigen;
  final String cuentaDestino;
  final String nombre;
  final String monto;

  TransferData({
    required this.cuentaOrigen,
    required this.cuentaDestino,
    required this.nombre,
    required this.monto,
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank App',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const TransferScreen(),
    );
  }
}

/* PANTALLA DE RECOPILACION DE DATOS PANTALLA 1*/

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController cuentaDestinoController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController montoController = TextEditingController();

  final String cuentaOrigen = "21-301-052260-9";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Header(),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    "Transferencia Terceros",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: _TransferCard(
                      cuentaOrigen: cuentaOrigen,
                      cuentaDestinoController: cuentaDestinoController,
                      nombreController: nombreController,
                      montoController: montoController,
                      onSubmit: () {
                        final data = TransferData(
                          cuentaOrigen: cuentaOrigen,
                          cuentaDestino: cuentaDestinoController.text,
                          nombre: nombreController.text,
                          monto: montoController.text,
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfirmationScreen(data: data),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const _BottomNav(), // 👈 AQUÍ VA EL MENÚ
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding:
          const EdgeInsets.only(top: 20, bottom: 4), // 👈 poco margen inferior
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF6A54C), Color(0xFFFF6A00)],
        ),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/logo.png',
          height: 60, // ↑ más grande
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _InputField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SubmitButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 200, // ancho fijo
          height: 50,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7ED957), Color(0xFF00A651)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              "Siguiente",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TransferCard extends StatelessWidget {
  final String cuentaOrigen;
  final TextEditingController cuentaDestinoController;
  final TextEditingController nombreController;
  final TextEditingController montoController;
  final VoidCallback onSubmit;

  const _TransferCard({
    required this.cuentaOrigen,
    required this.cuentaDestinoController,
    required this.nombreController,
    required this.montoController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Ingresar Datos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Cuenta Origen"),
              const SizedBox(height: 8),
              _ReadOnlyField(value: cuentaOrigen),
              const SizedBox(height: 16),
              _ToggleMock(),
              const SizedBox(height: 16),
              _InputField(
                label: "Cuenta Destino",
                controller: cuentaDestinoController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _InputField(
                label: "Nombre",
                controller: nombreController,
              ),
              const SizedBox(height: 16),
              _InputField(
                label: "Monto",
                controller: montoController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _SubmitButton(onTap: onSubmit),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String value;

  const _ReadOnlyField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(value),
    );
  }
}

class _ToggleMock extends StatelessWidget {
  const _ToggleMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  "Nueva Cuenta",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                "Favoritas",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* PANTALLA DE CONFIRMACION PANTALLA 2*/

//esta clase queda como widget que solo recibe datos
class ConfirmationScreen extends StatefulWidget {
  final TransferData data;

  const ConfirmationScreen({super.key, required this.data});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

// ahora aqui va todo el codigo de el layout de confirmacion
//corona
class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  String _formatCuenta(String cuenta) {
    final digits = cuenta.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 11) return cuenta;
    return '${digits.substring(0, 2)}-${digits.substring(2, 5)}-${digits.substring(5, 11)}-${digits.substring(11, 12)}';
  }

  String _formatMonto(String monto) {
    final value = double.tryParse(monto) ?? 0.0;
    return 'L  ${value.toStringAsFixed(2)}';
  }

  String _generarReferencia() {
    final random = Random();
    final numero = 1000000 + random.nextInt(9000000);
    return numero.toString();
  }

  @override
  Widget build(BuildContext context) {
    final referencia = _generarReferencia();

    return Scaffold(
      body: Column(
        children: [
          const _Header(),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "Transferencia Terceros",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 2,
                  bottom: 8,
                ), //este es el margen entre el contenedor y el contenido
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 TÍTULO + COMPARTIR
                    SizedBox(
                      height:
                          76, // 👈 altura explícita para que Positioned no se corte
                      child: Stack(
                        children: [
                          // Título centrado absolutamente
                          const Align(
                            alignment: Alignment.center,
                            child: Center(
                              child: Text(
                                "Transferencia Exitosa",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Share anclado a la derecha
                          Positioned(
                            right: 20,
                            top: 30,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .end, // 👈 alinea a la derecha
                              children: [
                                Image.asset(
                                  'assets/images/share001.png',
                                  height: 45,
                                  width: 60,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 0),

                    // 🔹 CHECK CENTRADO
                    Center(
                      child: Image.asset(
                        'assets/images/check001.png',
                        height: 75, //tamano de el check
                        width: 75, //tamano de el check
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Campos de confirmación
                    _ConfirmField(
                        label: "Cuenta Origen",
                        value: widget.data.cuentaOrigen),
                    const SizedBox(height: 4),
                    _ConfirmField(
                        label: "Cuenta Destino",
                        value: _formatCuenta(widget.data.cuentaDestino)),
                    const SizedBox(height: 4),
                    _ConfirmField(
                      label: "Nombre",
                      value: widget.data.nombre.toUpperCase(),
                      singleLine:
                          true, // 👈 este campo se corta si es muy grande la cadena
                    ),
                    const SizedBox(height: 4),
                    _ConfirmField(
                        label: "Monto Transferido",
                        value: _formatMonto(widget.data.monto)),
                    const SizedBox(height: 4),
                    _ConfirmField(label: "Referencia", value: referencia),

                    const SizedBox(
                        height:
                            30), //space between last textbox and green buttons

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            label: "Nueva\nTransferencia",
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            label: "Volver al Inicio",
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const _BottomNav(),
        ],
      ),
    );
  }
}

// campo de solo lectura para confirmacion
class _ConfirmField extends StatelessWidget {
  final String label;
  final String value;
  final bool singleLine; // 👈 parametro que controla el overflow de texto

  const _ConfirmField({
    required this.label,
    required this.value,
    this.singleLine = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            maxLines: singleLine ? 1 : null, // 👈
            overflow:
                singleLine ? TextOverflow.ellipsis : TextOverflow.visible, // 👈
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

// Botón verde reutilizable
class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7ED957), Color(0xFF00A651)],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: const Color(0xFF2C2C2C), // 👈 gris oscuro más parecido al mockup
      padding: const EdgeInsets.symmetric(horizontal: 20), // 👈 más margen
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // 👈 agrupa más al centro
        children: const [
          _NavItem(icon: Icons.home, label: "Inicio"),
          _NavItem(icon: Icons.settings, label: "Gestiones"),
          _NavItem(
            icon: Icons.sync_alt, // 👈 nuevo icono mejor
            label: "Transferencias o\nPagos",
            isActive: true,
          ),
          _NavItem(
            icon: Icons.security,
            label: "Seguridad o\nPreferencias",
          ),
          _NavItem(icon: Icons.logout, label: "Salir"),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? Colors.orange : Colors.grey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min, // 👈 no ocupa más espacio del necesario
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 10,
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
