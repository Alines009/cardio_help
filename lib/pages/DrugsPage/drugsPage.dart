import 'package:cardio_help/objects/custom_drawer/custom_navigator_drawer.dart';
import 'package:cardio_help/pages/DrugsPage/Tabs/CareTab.dart';
import 'package:cardio_help/pages/DrugsPage/Tabs/DetailsTab.dart';
import 'package:cardio_help/pages/DrugsPage/Tabs/InteractionTab.dart';
import 'package:cardio_help/pages/DrugsPage/Tabs/ClassificationTab.dart';
import 'package:cardio_help/pages/DrugsPage/Tabs/AdverseReactionTab.dart';
import 'package:cardio_help/pages/DrugsPage/Tabs/TherapeuticUse.dart';
import 'package:flutter/material.dart';
import 'package:cardio_help/theme/theme.dart' as theme;

class DrugsPage extends StatefulWidget { 
  final Map drug; //drugs selecionado anteriormente

  const DrugsPage(
    { 
      Key key,
      @required this.drug,
    }
  ): super(key: key); 

  @override
  _DrugsPageState createState() {
    return new _DrugsPageState();
  }
}

class _DrugsPageState extends State<DrugsPage>
    with SingleTickerProviderStateMixin {
  double maxWidth = 300;
  double minWidth = 70;
  
  bool isNotCollapsed = false;  // Variável de controle da execução da animação. No caso, se vai executar o foward ou reverse
  AnimationController _animationController; 
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;
 
  List tabs; 
  @override
  void initState() {
    this.tabs = [
      ClassificationTab(drug: widget.drug,),    //Classificação/Efeitos
      TherapeuticUseTab(drug: widget.drug,),    //Uso Terapêutico
      AdverseReactionTab(drug: widget.drug,),   //Evento Adverso
      DetailsTab(drug: widget.drug,),           //Detalhes
      InteractionTab(drug: widget.drug,),       //Interação
      CareTab(drug: widget.drug,),              //Cuidados
  ];

    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: minWidth, end: maxWidth)
        .animate(_animationController);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, //Retira a seta de voltar
          backgroundColor: theme.backgroundColor,
          title: new Center(child: new Text(widget.drug["name"], textAlign: TextAlign.center)),
      ),

      body: Stack(
          children: <Widget>[ //Cria a lista de topicos do drug
            this.tabs[currentSelectedIndex],
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, widget) => getWidget(context, widget),
            ),
          ],
        ),
    );
  }

  Widget getWidget(context, widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        width: widthAnimation.value,
        color: theme.backgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: CollapsingListTile( //Voltar para pagina anterior
                    title: 'Voltar', 
                    icon: Icons.arrow_back, 
                    animationController: _animationController, 
                    onTap:() {
                     Navigator.pop(context);
                    }
                  ),
                )
              ]
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, counter) {
                  return Divider(height: 30.0);
                },

                itemBuilder: (context, counter) {
                  return CollapsingListTile( 
                      onTap: () {
                        setState(() {
                          currentSelectedIndex = counter;
                        });
                      },
                      isSelected: currentSelectedIndex == counter,
                      title: itens[counter].title,
                      icon: itens[counter].icon,
                      animationController: _animationController,
                  );
                },
                itemCount: itens.length,
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isNotCollapsed = !isNotCollapsed;
                  isNotCollapsed
                      ? _animationController.forward()
                      : _animationController.reverse();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: _animationController,
                color: theme.selectedColor,
                size: 50.0,
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
