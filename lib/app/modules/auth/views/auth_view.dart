// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/auth_controller.dart';

// class AuthView extends StatelessWidget {
//   final AuthController controller = Get.put(AuthController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF6F42C1),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 _buildHeader(),
//                 SizedBox(height: 40),
//                 _buildLoginForm(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Column(
//       children: [
//         // Logo
//         TweenAnimationBuilder<double>(
//           duration: Duration(milliseconds: 800),
//           tween: Tween(begin: 0.0, end: 1.0),
//           builder: (context, value, child) {
//             return Transform.scale(
//               scale: value,
//               child: Container(
//                 width: 80,
//                 height: 80,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 20,
//                       offset: Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.apps,
//                   size: 40,
//                   color: Color(0xFF6F42C1),
//                 ),
//               ),
//             );
//           },
//         ),
        
//         SizedBox(height: 24),
        
//         // Titre
//         TweenAnimationBuilder<Offset>(
//           duration: Duration(milliseconds: 600),
//           tween: Tween(begin: Offset(0, 0.3), end: Offset.zero),
//           builder: (context, offset, child) {
//             return SlideTransition(
//               position: AlwaysStoppedAnimation(offset),
//               child: Column(
//                 children: [
//                   Text(
//                     'Substance',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     'Connectez-vous à votre compte',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white.withOpacity(0.8),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildLoginForm() {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 800),
//       tween: Tween(begin: 0.0, end: 1.0),
//       curve: Curves.easeOutCubic,
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, 50 * (1 - value)),
//           child: Opacity(
//             opacity: value,
//             child: Container(
//               padding: EdgeInsets.all(32),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 30,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: controller.formKey,
//                 child: Column(
//                   children: [
//                     // Email Field
//                     TextFormField(
//                       controller: controller.emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         labelText: 'Email',
//                         hintText: 'admin@test.com',
//                         prefixIcon: Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Veuillez entrer votre email';
//                         }
//                         if (!GetUtils.isEmail(value)) {
//                           return 'Veuillez entrer un email valide';
//                         }
//                         return null;
//                       },
//                     ),
                    
//                     SizedBox(height: 20),
                    
//                     // Password Field
//                     Obx(() => TextFormField(
//                       controller: controller.passwordController,
//                       obscureText: !controller.isPasswordVisible.value,
//                       decoration: InputDecoration(
//                         labelText: 'Mot de passe',
//                         hintText: 'password',
//                         prefixIcon: Icon(Icons.lock_outlined),
//                         suffixIcon: IconButton(
//                           onPressed: controller.togglePasswordVisibility,
//                           icon: Icon(
//                             controller.isPasswordVisible.value
//                                 ? Icons.visibility_off
//                                 : Icons.visibility,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Color(0xFF6F42C1), width: 2),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Veuillez entrer votre mot de passe';
//                         }
//                         if (value.length < 6) {
//                           return 'Le mot de passe doit contenir au moins 6 caractères';
//                         }
//                         return null;
//                       },
//                     )),
                    
//                     SizedBox(height: 16),
                    
//                     // Remember Me & Forgot Password
//                     Row(
//                       children: [
//                         Obx(() => Checkbox(
//                           value: controller.rememberMe.value,
//                           onChanged: (value) => controller.rememberMe.value = value ?? false,
//                           activeColor: Color(0xFF6F42C1),
//                         )),
//                         Text('Se souvenir de moi'),
//                         Spacer(),
//                         TextButton(
//                           onPressed: () {
//                             // TODO: Forgot password logic
//                           },
//                           child: Text(
//                             'Mot de passe oublié ?',
//                             style: TextStyle(color: Color(0xFF6F42C1)),
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     SizedBox(height: 24),
                    
//                     // Login Button
//                     Obx(() => Container(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: controller.isLoading.value ? null : controller.login,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF6F42C1),
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: controller.isLoading.value
//                     ? SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                         ),
//                       )
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add, size: 20),
//                           SizedBox(width: 8),
//                           Text(
//                             'Ajouter le produit',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             )),
//           ),
//         );
//       },
//     );
//   }
// }

