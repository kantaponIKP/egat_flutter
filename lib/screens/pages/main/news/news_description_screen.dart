import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/widgets/single_child_scoped_scroll_view.dart'; //TODO:
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NewsDescriptionScreen extends StatefulWidget {
  const NewsDescriptionScreen(
      {Key? key, required this.title, required this.content})
      : super(key: key);
  final String title;
  final String content;
  @override
  _NewsDescriptionScreenState createState() => _NewsDescriptionScreenState();
}

class _NewsDescriptionScreenState extends State<NewsDescriptionScreen> {
  bool _showBackToTopButton = false;

  ScrollController? _scrollController;

  initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          if (_scrollController!.offset >= 10) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
  }

  void dispose() {
    _scrollController!.dispose(); // dispose the controller
    super.dispose();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _scrollController!.animateTo(0,
        duration: Duration(milliseconds: 100), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(
        child: _buildAction(context),
      ),
      floatingActionButton: _showBackToTopButton == false
          ? null
          : FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.keyboard_arrow_up),
              backgroundColor: primaryColor,
            ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 6),
      child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              //TODO: loop
              _buildTitle(),
              // SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 60),
                child: _buildContent(),
              ),
              // SizedBox(height: 12),
            ],
          )),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: this.widget.title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    String temp =
        "  วันนี้ (13 สิงหาคม 2564) นายกิจจา ศรีพัฑฒางกุระ กรรมการผู้จัดการใหญ่ บริษัท ราช กรุ๊ป จำกัด (มหาชน) หรือ RATCH พร้อมด้วยนายเทพรัตน์ เทพพิทักษ์ กรรมการผู้จัดการใหญ่ บริษัท ผลิตไฟฟ้า จำกัด(มหาชน) หรือ EGCO และนายจรัญ คำเงิน ผู้ช่วยผู้ว่าการบริหารจัดการความยั่งยืน การไฟฟ้าฝ่ายผลิตแห่งประเทศไทย (กฟผ.) ร่วมพิธีมอบเงินให้แก่มูลนิธิยามเฝ้าแผ่นดินจำนวน 3 ล้านบาทเพื่อสมทบทุนในการจัดหายาฟ้าทะลายโจรให้แก่ผู้ป่วยโควิด -19 โดยมีนายปานเทพ พัวพงษ์พันธ์ รองประธานโครงการสนับสนุนการใช้ฟ้าทะลายโจรเพื่อช่วยประชาชนในช่วงโควิด-19 เป็นผู้แทนรับมอบผ่านระบบออนไลน์" +
            "นายกิจจา ศรีพัฑฒางกุระ กรรมการผู้จัดการใหญ่ RATCH ในฐานะผู้แทนกลุ่ม กฟผ. เปิดเผยว่า กลุ่ม กฟผ. พร้อมเป็นอีกหนึ่งภาคส่วนในการช่วยเหลือสนับสนุนหน่วยงานต่าง ๆ เพื่อบรรเทาผลกระทบจากการแพร่ระบาดของเชื้อโควิด-19 อย่างสุดกำลัง ตั้งแต่การจัดหาอุปกรณ์ทางการแพทย์ การผลิตนวัตกรรมทางการแพทย์ เตียงสนาม รวมถึงจัดหาอาหารและสิ่งของจำเป็นมอบให้แก่ประชาชน โดยในโอกาสนี้ กฟผ. RATCH และ EGCO ร่วมกันมอบเงินให้แก่มูลนิธิยามเฝ้าแผ่นดินจำนวน 3 ล้านบาท เพื่อสมทบทุนในการจัดหายาฟ้าทะลายโจรชนิดแคปซูล รวมถึงฟ้าทะลายโจรแบบต้นสดหรือต้นตากแห้งที่จะนำไปเป็นวัตถุดิบในการผลิตยาฟ้าทะลายโจรให้แก่ผู้ป่วยโควิด -19 สำหรับนำไปแจกจ่ายให้แก่ผู้ป่วยและคลัสเตอร์ที่มีการแพร่ระบาดของเชื้อโควิด-19 ในพื้นที่ต่าง ๆ เพื่อบรรเทาอาการระหว่างรอเข้ารับการรักษา และผ่านพ้นวิกฤตโควิด-19 ไปได้โดยเร็วที่สุด" +
            "ด้านนายปานเทพ พัวพงษ์พันธ์ รองประธานโครงการสนับสนุนการใช้ฟ้าทะลายโจรเพื่อช่วยประชาชนในช่วงโควิด-19 มูลนิธิยามเฝ้าแผ่นดิน กล่าวว่า มูลนิธิยามเฝ้าแผ่นดินได้ดำเนินการจัดหาฟ้าทะลายโจรชนิดแคปซูลฟ้าทะลายโจรแบบต้นสดและตากแห้ง รวมถึงวัตถุดิบในการผลิตขิงผงที่เป็นยาฤทธิ์ร้อนที่ใช้รับประทานคู่กับยาฟ้าทะลายโจรเพื่อลดอาการข้างเคียง มอบให้แก่ชุมชนแออัด วัด และโรงพยาบาลต่าง ๆ ในพื้นที่ที่มีการแพร่ระบาดของเชื้อโควิด-19 ทางมูลนิธิยามเฝ้าแผ่นดินรู้สึกยินดีเป็นอย่างยิ่งที่ได้ร่วมมือกับกลุ่ม กฟผ. ซึ่งเป็นองค์กรเสาหลักที่ช่วยเหลือสังคมมาในทุกวิกฤตมาอย่างต่อเนื่องและยาวนานนอกเหนือจากภารกิจด้านพลังงานไฟฟ้าทั้งในยามที่ประชาชนต้องการความช่วยเหลือการดูแลชุมชนสิ่งแวดล้อมซึ่งการสนับสนุนการจัดหายาฟ้าทะลายโจรในครั้งนี้ของกลุ่ม กฟผ. จะทำให้ยาฟ้าทะลายโจรเข้าถึงประชาชนที่ขาดโอกาสในการรักษาและผู้ป่วยโควิด-19 มากยิ่งขึ้น ตลอดจนช่วยลดความรุนแรงของการแพร่ระบาดของเชื้อโควิดให้อยู่ในวงจำกัดอีกด้วย";
    return 
    MarkdownBody(
      data: this.widget.content,
      shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
    );
    // Markdown(
    //   data: this.widget.content,
    //   shrinkWrap: true,
    //   physics: NeverScrollableScrollPhysics(),
    // );

    // return Align(
    //   alignment: Alignment.centerLeft,
    //   child: RichText(
    //       text: TextSpan(
    //     children: [
    //       TextSpan(
    //         text: this.widget.content,
    //         // text: temp,
    //         style: TextStyle(
    //           fontSize: 14,
    //         ),
    //       ),
    //     ],
    //   )),
    // );
  }
}
