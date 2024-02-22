import SwiftUI

struct IntroductionView: View {
//    let texts = ["Nós normalmente pensamos em ritmo como um elemento da música, marcado pela sucessão regular de sons musicais e silêncios", "No entanto, o ritmo existe em tudo que flui ou se movimenta de modo regular", "Por exemplo, imagine que você está na Mata Atlântica, um bioma brasileiro caracterizado pela grande biodiversidade", "Escute o canto desse pássaro. O que você está ouvindo é uma maria-cavaleira, uma espécie presente em todo o Brasil", "Agora, escute o canto da pica-pau-verde-barrado, espécie comum na maior parte da América do Sul", "O que acontece se você escutar os dois ao mesmo tempo?", "Nesse caso, você consegue perceber que cada som possui o próprio ritmo, mas se assumirmos uma velocidade constante, eventualmente eles se encontram", "Isso é chamado de polirritmia, e acontece o tempo todo na música, mas também na natureza", "Matematicamente, podemos visualizar cada ritmo como um polígono regular, onde o primeiro vértice de cada polígono é a batida em que os dois ritmos se encontram", "To practice, place the iPad on a table. Whenever the red circle touches the vertice of a polygon, press the button with the same color."]
    let texts = ["We usually think of rhythm as an element of music, marked by the regular succession of musical sounds and silences.", "However, rhythm exists in everything that flows or moves in a regular manner.", "For example, imagine you are in the Atlantic Forest, a Brazilian biome characterized by its vast biodiversity.", "Listen to the song of this bird. What you are hearing is a \"maria-cavaleira\" (short-crested flycatcher), a species found throughout Brazil.", "Now, listen to the call of the \"pica-pau-verde-barrado\" (green-barred woodpecker), a species common in most parts of South America.", "What happens if you listen to both at the same time?", "In this case, you can notice that each sound has its own rhythm, but if we assume a constant speed, they eventually synchronize or intersect.", "That's called polyrhythm, and it occurs all the time in music but also in nature.", "Mathematically, we can visualize each rhythm as a regular polygon, where the first vertex of each polygon is the beat at which the two rhythms align.", "Place the iPad on a table. Whenever the red circle touches the vertice of a polygon, press the button with the same color.", "Watch the simulation to understand the timing of each beat, and click Ready when you want to start practicing."]
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
    @State var circlesOpacity = 0.0
    
    // Controls tap texts
    @State var leftTextVisible = false
    @State var rightTextVisible = false
    @State var isAnimating = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                // Image that appears during return animation
                if imageIndex-1 <= 3 && imageIndex-1 >= 0 {
                    Image("image\(imageIndex-1)")
                        .resizable()
                        .offset(x: backMovingRight ? 0 : -UIScreen.main.bounds.width)
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                }
                // Image that appears in the center
                if imageIndex <= 3 {
                    Image("image\(imageIndex)")
                        .resizable()
                        .offset(x: centerMovingLeft ? -UIScreen.main.bounds.width : 0)
                        .offset(x: centerMovingRight ? UIScreen.main.bounds.width : 0)
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                }
                // Image that appears during forward animation
                if imageIndex+1 <= 3 {
                    Image("image\(imageIndex+1)")
                        .resizable()
                        .offset(x: frontMovingLeft ? 0 : UIScreen.main.bounds.width)
                        .scaledToFit()
                }
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
                VStack(spacing: 64) {
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
                    HStack {
                        VStack(spacing: 16) {
                            Button {
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: 130)
                                        .opacity(circlesOpacity)
                                    Circle()
                                        .foregroundStyle(Color(hex: "#84AF7C"))
                                        .frame(maxWidth: 120)
                                        .opacity(circlesOpacity)
                                }
                            }
                            .disabled(true)
                            Text("Tap")
                                .foregroundStyle(Color(hex: "#663F1B"))
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .opacity(leftTextVisible ? 1 : 0)
                        }
                        Spacer()
                        VStack(spacing: 16) {
                            Button {
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: 130)
                                        .opacity(circlesOpacity)
                                    Circle()
                                        .foregroundStyle(Color(hex: "#D1875D"))
                                        .frame(maxWidth: 120)
                                        .opacity(circlesOpacity)
                                }
                            }
                            .disabled(true)
                            Text("Tap")
                                .foregroundStyle(Color(hex: "#663F1B"))
                                .font(.system(size: 32, weight: .bold, design: .rounded))
                                .opacity(rightTextVisible ? 1 : 0)
                        }
                    }
                    .padding(.horizontal, 76)
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
                                SoundManager.instance.stopBirdSounds()
                                withAnimation(.easeIn(duration: 0.2)) {
                                    firstBirdOffset = UIScreen.main.bounds.width
                                }
                            case 3:
                                SoundManager.instance.stopBirdSounds()
                                SoundManager.instance.playBirdSong(sound: .mariaCavaleira)
                                withAnimation(.easeOut(duration: 0.2)) {
                                    firstBirdOffset = -100
                                }
                                withAnimation(.easeIn(duration: 0.2)) {
                                    secondBirdOffset = UIScreen.main.bounds.width
                                }
                            case 4:
                                SoundManager.instance.stopBirdSounds()
                                SoundManager.instance.playBirdSong(sound: .picaPau)
                                withAnimation(.easeIn(duration: 0.2)) {
                                    firstBirdOffset = -UIScreen.main.bounds.width
                                }
                            case 5:
                                SoundManager.instance.stopBirdSounds()
                                SoundManager.instance.playBirdSong(sound: .mariaCavaleira)
                                SoundManager.instance.playBirdSong(sound: .picaPau)
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
                            case 9:
                                withAnimation {
                                    circlesOpacity = 0
                                }
                                leftTextVisible = false
                                rightTextVisible = false
                            default: break
                            }
                        } label: {
                            Image(systemName: "chevron.backward.square.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Color(hex: "227033"))
                                .opacity(textIndex == 0 ? 0.3 : 1)
                        }
                        .disabled(textIndex == 0 || backMovingRight || centerMovingLeft || centerMovingRight || frontMovingLeft || isAnimating)
                        
                        Spacer()
                        
                        // Button to advance text
                        Button {
                            if textIndex == 10 {
                                UserDefaults.standard.setValue(true, forKey: "hasSeenOnboarding")
                                SoundManager.instance.stopBirdSounds()
                                dismiss()
                            } else {
                                textIndex += 1
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
                                    SoundManager.instance.playBirdSong(sound: .mariaCavaleira)
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        firstBirdOffset = -100
                                    }
                                case 4:
                                    SoundManager.instance.stopBirdSounds()
                                    SoundManager.instance.playBirdSong(sound: .picaPau)
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        firstBirdOffset = -UIScreen.main.bounds.width
                                        secondBirdOffset = 100
                                    }
                                case 5:
                                    SoundManager.instance.stopBirdSounds()
                                    SoundManager.instance.playBirdSong(sound: .mariaCavaleira)
                                    SoundManager.instance.playBirdSong(sound: .picaPau)
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        firstBirdOffset = -100
                                        secondBirdOffset = 100
                                    }
                                case 6:
                                    SoundManager.instance.stopBirdSounds()
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
                                    isAnimating = true
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        centerMovingLeft = true
                                    } completion: {
                                        imageIndex += 1
                                        centerMovingLeft = false
                                        withAnimation(.easeOut(duration: 0.4)) {
                                            triangleOffset = 0
                                            triangleCircleX = 0
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 0)
                                        }
                                        withAnimation(.linear(duration: 2/3).delay(0.4)) {
                                            triangleCircleX = 261.24355652982143/2
                                            triangleCircleY = 280 - 209.99999999999997
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 1)
                                        }
                                        withAnimation(.linear(duration: 2/3).delay(0.4 + 2/3)) {
                                            triangleCircleX = -261.24355652982143/2
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 2)
                                        }
                                        withAnimation(.linear(duration: 2/3).delay(0.4 + 4/3)) {
                                            triangleCircleX = 0
                                            triangleCircleY = -140
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 0)
                                        }
                                        withAnimation(.easeOut(duration: 0.4).delay(2.4)) {
                                            squareOffset = 0
                                            squareCircleX = 0
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 0)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(2.8)) {
                                            squareCircleX = 140
                                            squareCircleY = 0
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 1)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(3.3)) {
                                            squareCircleX = 0
                                            squareCircleY = 140
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 2)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(3.8)) {
                                            squareCircleX = -140
                                            squareCircleY = 0
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 3)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(4.3)) {
                                            squareCircleX = 0
                                            squareCircleY = -140
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 0)
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 0)
                                        }
                                        // Os dois juntos
                                        withAnimation(.linear(duration: 2/3).delay(4.8)) {
                                            triangleCircleX = 261.24355652982143/2
                                            triangleCircleY = 280 - 209.99999999999997
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 1)
                                        }
                                        withAnimation(.linear(duration: 2/3).delay(4.8 + 2/3)) {
                                            triangleCircleX = -261.24355652982143/2
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 2)
                                        }
                                        withAnimation(.linear(duration: 2/3).delay(4.8 + 4/3)) {
                                            triangleCircleX = 0
                                            triangleCircleY = -140
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 0)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(4.8)) {
                                            squareCircleX = 140
                                            squareCircleY = 0
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 0)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(5.3)) {
                                            squareCircleX = 0
                                            squareCircleY = 140
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 1)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(5.8)) {
                                            squareCircleX = -140
                                            squareCircleY = 0
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 2)
                                        }
                                        withAnimation(.linear(duration: 0.5).delay(6.3)) {
                                            squareCircleX = 0
                                            squareCircleY = -140
                                        } completion: {
                                            SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 3)
                                            isAnimating = false
                                        }
                                    }
                                case 10:
                                    withAnimation {
                                        circlesOpacity = 1
                                    }
                                    leftTextVisible = true
                                    rightTextVisible = true
                                    isAnimating = true
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                                        leftTextVisible = false
                                        rightTextVisible = false
                                    }
                                    withAnimation(.linear(duration: 4.0/3.0).delay(1)) {
                                        triangleCircleX = 261.24355652982143/2
                                        triangleCircleY = 280 - 209.99999999999997
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 0)
                                        leftTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            leftTextVisible = false
                                        }
                                    }
                                    withAnimation(.linear(duration: 4.0/3.0).delay(1 + 4.0/3.0)) {
                                        triangleCircleX = -261.24355652982143/2
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 1)
                                        leftTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            leftTextVisible = false
                                        }
                                    }
                                    withAnimation(.linear(duration: 4.0/3.0).delay(1 + 8.0/3.0)) {
                                        triangleCircleX = 0
                                        triangleCircleY = -140
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .mariaCavaleiraShort, player: 2)
                                        leftTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            leftTextVisible = false
                                        }
                                    }
                                    withAnimation(.linear(duration: 1).delay(1)) {
                                        squareCircleX = 140
                                        squareCircleY = 0
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 0)
                                        rightTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            rightTextVisible = false
                                        }
                                    }
                                    withAnimation(.linear(duration: 1).delay(2)) {
                                        squareCircleX = 0
                                        squareCircleY = 140
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 1)
                                        rightTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            rightTextVisible = false
                                        }
                                    }
                                    withAnimation(.linear(duration: 1).delay(3)) {
                                        squareCircleX = -140
                                        squareCircleY = 0
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 2)
                                        rightTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            rightTextVisible = false
                                        }
                                    }
                                    withAnimation(.linear(duration: 1).delay(4)) {
                                        squareCircleX = 0
                                        squareCircleY = -140
                                    } completion: {
                                        SoundManager.instance.playBirdSound(sound: .picaPauShort, player: 3)
                                        rightTextVisible = true
                                        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                                            rightTextVisible = false
                                        }
                                        isAnimating = false
                                    }
                                default: break
                                }
                            }
                        } label: {
                            if (textIndex == 10) {
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
                        .disabled(backMovingRight || centerMovingLeft || centerMovingRight || frontMovingLeft || isAnimating)
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
