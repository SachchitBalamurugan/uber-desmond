import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/user_info_provider.dart';

class UserNameBuilder extends StatelessWidget {
  const UserNameBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder<String>(
          stream: context.read<UserInfoModelProvider>().getUserName(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text('${snapshot.data}',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              );
            }else if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Text('Loading...',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),);
            }else{
              return const Text('Welcome, USER');

            }
          },
        ),
      ],
    );
  }
}