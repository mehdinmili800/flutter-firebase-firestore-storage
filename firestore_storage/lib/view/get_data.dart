import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GetData extends StatefulWidget {
  const GetData({super.key});

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('image gallery')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 80.w),
              child: Text(
                'my picture',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('imageDetails')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshot.data!.docs;
                return Container(
                  margin: EdgeInsets.only(left: 20.w),
                  
                  child: Column(
                    children: [
                      SizedBox(
                        height: 800.h,
                        width: 300.w,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            final name = documents[index]['name'];
                            final imageUrl = documents[index]['imageUrl'];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  
                                  margin: EdgeInsets.only(top: 20.h),
                                  height: 150.h,
                                  width: 170,
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  height: 150.h,
                                  width: 170,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(135, 255, 193, 7),
                                          borderRadius:
                                              BorderRadius.circular(26)),
                                      margin: EdgeInsets.only(),
                                      child: Container(
                                        margin: EdgeInsets.only(left: 20,top: 30),
                                        child: Text(
                                          name,
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )),
                                )
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
