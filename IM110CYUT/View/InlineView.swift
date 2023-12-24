//
//  InlineView.swift
//  StickyHeaderExample
//
//  Created by 曾品瑞 on 2023/12/11.
//

import SwiftUI

struct InlineView: View {
    //MARK: 歌曲列表
    private var song: [String] {
        let name: [String]=["森林", "海洋", "微風", "火焰", "自然"]
        var result: [String]=[]
        
        for i in 0..<30 {
            result.append(name[i%name.count].appending("音樂"))
        }
        
        return result
    }
    
    //MARK: 封面畫面
    @ViewBuilder
    private func CoverView(safeArea: EdgeInsets, size: CGSize) -> some View {
        let height: CGFloat=size.height*0.5
        
        GeometryReader {reader in
            //ScrollView的最小Y值
            let minY: CGFloat=reader.frame(in: .named("SCROLL")).minY
            //當前畫面的大小
            let size: CGSize=reader.size
            //滑動狀態的數值
            let progress: CGFloat=minY/(height*(minY>0 ? 0.5:0.8))
            
            Image(.泡麵)
                .resizable()
                .scaledToFill()
            //圖片根據size及minY改變長度
                .frame(width: size.width, height: size.height+(minY>0 ? minY:0))
                .clipped()
                .overlay {
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(
                                //根據progress值改變覆蓋在圖片上的陰影
                                .linearGradient(
                                    colors: [
                                        .black.opacity(0-progress),
                                        .black.opacity(0.2-progress),
                                        .black.opacity(0.4-progress),
                                        .black.opacity(0.6-progress),
                                        .black.opacity(0.8-progress),
                                        .black
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        VStack(spacing: 0) {
                            Text("品瑞音樂")
                                .bold()
                                .font(.largeTitle)
                            
                            Text("900,927 瀏覽次數/月")
                                .bold()
                                .font(.callout)
                                .foregroundStyle(.gray)
                                .padding(.top)
                        }
                        //利用progress的數值變化改變透明度 1.1會讓標題在HeaderView的位置消失
                        .opacity(1.1+(progress>0 ? -progress:progress))
                        .padding(.bottom, 50)
                        .offset(y: minY<0 ? minY:0)
                    }
                }
            //網上滑動的時候 圖片及陰影也要跟著網上滑動
                .offset(y: -minY)
            //MARK: CoverView的progress
                .onChange(of: progress) {
                    print("CoverView的progress值: \(progress)")
                }
        }
        .frame(height: height+safeArea.top)
    }
    //MARK: 標題畫面
    @ViewBuilder
    private func HeaderView(size: CGSize) -> some View {
        GeometryReader {reader in
            //ScrollView的最小Y值
            let minY: CGFloat=reader.frame(in: .named("SCROLL")).minY
            let height: CGFloat=size.height*0.5
            //滑動狀態的數值
            let progress: CGFloat=minY/(height*(minY>0 ? 0.5:0.8))
            
            HStack(spacing: 20) {
                Button("", systemImage: "heart") {}
                    .font(.title2)
                    .animation(.none, value: progress)
                
                //利用progress的數值變化改變透明度 11會讓專輯標題在HeaderView的位置時 消失以下內容
                if(progress>11) {
                    Spacer(minLength: 0)
                    
                    Button {
                        
                    } label: {
                        Text("追蹤")
                            .bold()
                            .font(.callout)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Rectangle().stroke(lineWidth: 1))
                            .animation(.none, value: progress)
                    }
                    .opacity(progress-11)
                    //利用progress的數值變化改變透明度 11會讓專輯標題在HeaderView的位置時 出現以下內容
                } else {
                    Spacer(minLength: 0)
                    
                    Text("品瑞音樂")
                        .bold()
                        .font(.title3)
                        .transition(.opacity.animation(.smooth))
                    
                    Spacer(minLength: 0)
                }
                
                Button("", systemImage: "ellipsis") {}
                    .font(.title2)
                    .animation(.none, value: progress)
            }
            .foregroundStyle(.white)
            .padding()
            //利用progress的數值變化改變透明度 11會讓專輯標題在HeaderView的位置時 出現背景顏色
            .background(.black.opacity(progress>11 ? 0:1))
            .animation(.smooth.speed(2), value: progress>11)
            .offset(y: -minY)
            //MARK: HeaderView的progress
            .onChange(of: progress) {
                print("HeaderView的progress值: \(progress)")
            }
        }
    }
    //MARK: 歌曲畫面
    @ViewBuilder
    private func SongView(safeArea: EdgeInsets) -> some View {
        VStack(spacing: 20) {
            ForEach(self.song.indices, id: \.self) {index in
                HStack(spacing: 30) {
                    Text("\(index+1<10 ? "0":"")\(index+1)")
                        .bold()
                        .font(.callout)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(self.song[index]).bold()
                        
                        Text("曾品瑞").font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "ellipsis")
                }
            }
        }
        .foregroundStyle(.white.opacity(0.8))
        .padding()
        .transition(.opacity)
    }
    
    var body: some View {
        GeometryReader {
            //當前畫面的safeArea
            let safeArea: EdgeInsets=$0.safeAreaInsets
            //GeometryReader的大小
            let size: CGSize=$0.size
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    //MARK: CoverView
                    self.CoverView(safeArea: safeArea, size: size)
                    
                    Text("享受每個風格的聽覺饗宴")
                        .bold()
                        .font(.body)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.top, -30)
                    
                    //MARK: SongView
                    self.SongView(safeArea: safeArea).padding(.top)
                    
                    //MARK: HeaderView
                    self.HeaderView(size: size)
                }
            }
            //抓取ScrollView的各項數值
            .coordinateSpace(name: "SCROLL")
        }
        .toolbarBackground(.black, for: .navigationBar)
    }
}
struct InlineView_Previews: PreviewProvider
{
    static var previews: some View
    {
        InlineView()
    }
}
