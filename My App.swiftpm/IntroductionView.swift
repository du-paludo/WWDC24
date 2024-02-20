import SwiftUI

struct IntroductionView: View {
    let texts = ["Nós normalmente pensamos em ritmo como um elemento da música, marcado pela sucessão regular de sons musicais e silêncios", "No entanto, o ritmo existe em tudo que flui ou se movimenta de modo regular", "Agora, imagine que você está na Mata Atlântica, um bioma brasileiro caracterizado pela grande biodiversidade", "Escute o canto desse pássaro. O que você está ouvindo é uma maria-cavaleira, uma espécie presente em todo o Brasil", "Agora, escute o canto da pica-pau-verde-barrado, espécie comum na maior parte da América do Sul", "O que acontece se você escutar os dois ao mesmo tempo?", "Nesse caso, você consegue perceber que cada som possui o próprio ritmo, mas se assumirmos uma velocidade constante, eventualmente eles se encontram", "Isso é chamado de polirritmia, e acontece o tempo todo na música, mas também na natureza", "Matematicamente, podemos visualizar cada ritmo como um polígono regular, onde o primeiro vértice de cada polígono é a batida em que os dois ritmos se encontram", "Então, vamos praticar?"]
    @State var textIndex = 0
    @State var imageIndex = 0
    
    // Controls images animations
    @State var backMovingRight = false
    @State var centerMovingLeft = false
    @State var centerMovingRight = false
    @State var frontMovingLeft = false

    // Controls birds animations
    @State var firstBirdOffset = UIScreen.main.bounds.width
    @State var secondBirdOffset = UIScreen.main.bounds.width
    @State var triangleOffset = -UIScreen.main.bounds.width
    
    // Controls polygons animations
    @State var squareOffset = UIScreen.main.bounds.width
    @State var triangleCircleX = -UIScreen.main.bounds.width
    @State var triangleCircleY = -140.0
    @State var squareCircleX = UIScreen.main.bounds.width
    @State var squareCircleY = -140.0
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                // Image that appears during return animation
                Image("image\(imageIndex-1)")
                    .resizable()
                    .offset(x: backMovingRight ? 0 : -UIScreen.main.bounds.width)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                // Image that appears in the center
                Image("image\(imageIndex)")
                    .resizable()
                    .offset(x: centerMovingLeft ? -UIScreen.main.bounds.width : 0)
                    .offset(x: centerMovingRight ? UIScreen.main.bounds.width : 0)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                // Image that appears during forward animation
                Image("image\(imageIndex+1)")
                    .resizable()
                    .offset(x: frontMovingLeft ? 0 : UIScreen.main.bounds.width)
                    .scaledToFit()
                // Image of the short-crested flycatcher
                Image("bird1")
                    .resizable()
                    .offset(x: secondBirdOffset, y: -100)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.36)
                // Image of the green-barred woodpecker
                Image("bird2")
                    .resizable()
                    .offset(x: firstBirdOffset, y: 100)
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width * 0.4)
                
                // Polygons
                HStack {
                    ZStack(alignment: .center) {
                        RegularPolygon(sides: 3)
                            .stroke(lineWidth: 10)
                            .foregroundStyle(Color(hex: "#84AF7C"))
                            .offset(x: triangleOffset)
                        Circle()
                            .foregroundColor(Color(hex: "#AD2525"))
                            .frame(width: 32, height: 32)
                            .offset(x: triangleCircleX, y: triangleCircleY)
                    }
                    .frame(width: 280, height: 280)
                    Spacer()
                    ZStack {
                        RegularPolygon(sides: 4)
                            .stroke(lineWidth: 10)
                            .foregroundStyle(Color(hex: "#D1875D"))
                            .offset(x: squareOffset)
                        Circle()
                            .foregroundColor(Color(hex: "#AD2525"))
                            .frame(width: 32, height: 32)
                            .offset(x: squareCircleX, y: squareCircleY)
                    }
                    .frame(width: 280, height: 280)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            
            Spacer()
            
            // Text square
            ZStack() {
                Text(texts[textIndex])
                    .padding(.horizontal, 80)
                    .foregroundStyle(Color(hex: "#663F1B"))
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                VStack {
                    Spacer()
                    // Button to return text
                    HStack(alignment: .bottom) {
                        Button {
                            textIndex -= 1
                            switch textIndex {
                            case 0, 1:
                                withAnimation(.easeIn(duration: 0.2)) {
                                    centerMovingRight = true
                                } completion: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        backMovingRight = true
                                    } completion: {
                                        centerMovingRight = false
                                        backMovingRight = false
                                        imageIndex -= 1
                                    }
                                }
                            case 2:
                                SoundManager.instance.stopSounds()
                                withAnimation(.easeIn(duration: 0.2)) {
                                    firstBirdOffset = UIScreen.main.bounds.width
                                }
                            case 3:
                                SoundManager.instance.stopSounds()
                                SoundManager.instance.playSound(sound: .mariaCavaleira)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    firstBirdOffset = -100
                                }
                                withAnimation(.easeIn(duration: 0.2)) {
                                    secondBirdOffset = UIScreen.main.bounds.width
                                }
                            case 4:
                                SoundManager.instance.stopSounds()
                                SoundManager.instance.playSound(sound: .picaPau)
                                withAnimation(.easeIn(duration: 0.2)) {
                                    firstBirdOffset = -UIScreen.main.bounds.width
                                }
                            case 5:
                                SoundManager.instance.stopSounds()
                                SoundManager.instance.playSound(sound: .mariaCavaleira)
                                SoundManager.instance.playSound(sound: .picaPau)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    firstBirdOffset = -100
                                    secondBirdOffset = 100
                                    centerMovingRight = true
                                } completion: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        backMovingRight = true
                                    } completion: {
                                        centerMovingRight = false
                                        backMovingRight = false
                                        imageIndex -= 1
                                    }
                                }
                            case 7:
                                
                                withAnimation(.easeIn(duration: 0.4)) {
                                    triangleOffset = -UIScreen.main.bounds.width
                                    squareOffset = UIScreen.main.bounds.width
                                    triangleCircleX = -UIScreen.main.bounds.width
                                    squareCircleX = UIScreen.main.bounds.width
                                } completion: {
                                    triangleCircleY = -140
                                    squareCircleY = -140
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        backMovingRight = true
                                    } completion: {
                                        backMovingRight = false
                                        imageIndex -= 1
                                    }
                                }
                            default: break
                            }
                        } label: {
                            Image(systemName: "chevron.backward.square.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Color(hex: "227033"))
                                .opacity(textIndex == 0 ? 0.3 : 1)
                        }
                        .disabled(textIndex == 0 || backMovingRight || centerMovingLeft || centerMovingRight || frontMovingLeft)
                        
                        Spacer()
                        
                        // Button to advance text
                        Button {
                            if textIndex == 9 {
                                UserDefaults.standard.setValue(true, forKey: "hasSeenOnboarding")
                                dismiss()
                            } else {
                                textIndex += 1
                            }
                            switch textIndex {
                            case 1, 2:
                                withAnimation(.easeIn(duration: 0.2)) {
                                    centerMovingLeft = true
                                } completion: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        frontMovingLeft = true
                                    } completion: {
                                        centerMovingLeft = false
                                        frontMovingLeft = false
                                        imageIndex += 1
                                    }
                                }
                            case 3:
                                SoundManager.instance.playSound(sound: .mariaCavaleira)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    firstBirdOffset = -100
                                }
                            case 4:
                                SoundManager.instance.stopSounds()
                                SoundManager.instance.playSound(sound: .picaPau)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    firstBirdOffset = -UIScreen.main.bounds.width
                                    secondBirdOffset = 100
                                }
                            case 5:
                                SoundManager.instance.playSound(sound: .mariaCavaleira)
                                SoundManager.instance.playSound(sound: .picaPau)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    firstBirdOffset = -100
                                    secondBirdOffset = 100
                                }
                            case 6:
                                SoundManager.instance.stopSounds()
                                withAnimation(.easeIn(duration: 0.2)) {
                                    firstBirdOffset = -UIScreen.main.bounds.width
                                    secondBirdOffset = UIScreen.main.bounds.width
                                    centerMovingLeft = true
                                } completion: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        frontMovingLeft = true
                                    } completion: {
                                        centerMovingLeft = false
                                        frontMovingLeft = false
                                        imageIndex += 1
                                    }
                                }
                            case 8:
                                withAnimation(.easeIn(duration: 0.2)) {
                                    centerMovingLeft = true
                                } completion: {
                                    imageIndex += 1
                                    centerMovingLeft = false
                                    withAnimation(.easeOut(duration: 0.4)) {
                                        triangleOffset = 0
                                        triangleCircleX = 0
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 0)
                                    }
                                    withAnimation(.linear(duration: 2/3).delay(0.4)) {
                                        triangleCircleX = 261.24355652982143/2
                                        triangleCircleY = 280 - 209.99999999999997
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 1)
                                    }
                                    withAnimation(.linear(duration: 2/3).delay(0.4 + 2/3)) {
                                        triangleCircleX = -261.24355652982143/2
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 2)
                                    }
                                    withAnimation(.linear(duration: 2/3).delay(0.4 + 4/3)) {
                                        triangleCircleX = 0
                                        triangleCircleY = -140
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 0)
                                    }
                                    withAnimation(.easeOut(duration: 0.4).delay(2.4)) {
                                        squareOffset = 0
                                        squareCircleX = 0
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 0)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(2.8)) {
                                        squareCircleX = 140
                                        squareCircleY = 0
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 1)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(3.3)) {
                                        squareCircleX = 0
                                        squareCircleY = 140
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 2)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(3.8)) {
                                        squareCircleX = -140
                                        squareCircleY = 0
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 3)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(4.3)) {
                                        squareCircleX = 0
                                        squareCircleY = -140
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 0)
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 0)
                                    }
                                    // Os dois juntos
                                    withAnimation(.linear(duration: 2/3).delay(4.8)) {
                                        triangleCircleX = 261.24355652982143/2
                                        triangleCircleY = 280 - 209.99999999999997
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 1)
                                    }
                                    withAnimation(.linear(duration: 2/3).delay(4.8 + 2/3)) {
                                        triangleCircleX = -261.24355652982143/2
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 2)
                                    }
                                    withAnimation(.linear(duration: 2/3).delay(4.8 + 4/3)) {
                                        triangleCircleX = 0
                                        triangleCircleY = -140
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .mariaCavaleiraShort, player: 0)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(4.8)) {
                                        squareCircleX = 140
                                        squareCircleY = 0
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 0)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(5.3)) {
                                        squareCircleX = 0
                                        squareCircleY = 140
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 1)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(5.8)) {
                                        squareCircleX = -140
                                        squareCircleY = 0
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 2)
                                    }
                                    withAnimation(.linear(duration: 0.5).delay(6.3)) {
                                        squareCircleX = 0
                                        squareCircleY = -140
                                    } completion: {
                                        SoundManager.instance.playBeat(sound: .picaPauShort, player: 3)
                                    }
                                }
//                            case 9:
                                
                            default: break
                            }
                        } label: {
                            if (textIndex == 9) {
                                Text("Ready")
                                    .padding(8)
                                    .foregroundStyle(Color(hex: "#227033"))
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                            } else {
                                Image(systemName: "chevron.forward.square.fill")
                                    .font(.system(size: 48))
                                    .foregroundStyle(Color(hex: "227033"))
                                    .opacity(textIndex == (texts.count - 1) ? 0.3 : 1)
                            }
                        }
                        .disabled(backMovingRight || centerMovingLeft || centerMovingRight || frontMovingLeft)
                    }
                    .padding(24)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 240)
            .background {
                Image("rectangle")
                    .resizable()
            }
            .padding(48)
        }
        .background(Color(hex: "F5E2C6"))
    }
}

#Preview {
    IntroductionView()
}
