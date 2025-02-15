//
//  main.swift
//  SoftmaxOdev
//
//  Created by Rabia Cırık on 15.02.2025.
//


import Foundation

//Mahalle bilgilerini içeren struct
struct Mahalle {
    let ad: String
    let nufus: Double
    let altyapi: Double
    let maliyet: Double
    let cevreselEtki: Double
    let sosyalFayda: Double
}

//Mahalle verilerini tanımla
let mahalleler = [
    Mahalle(ad: "Cumhuriyet Mahallesi", nufus: 15000, altyapi: 5, maliyet: 3.5, cevreselEtki: 80, sosyalFayda: 7000),
    Mahalle(ad: "Karakaş Mahallesi", nufus: 20000, altyapi: 7, maliyet: 4.2, cevreselEtki: 100, sosyalFayda: 9000),
    Mahalle(ad: "İstasyon Mahallesi", nufus: 10000, altyapi: 3, maliyet: 2.8, cevreselEtki: 60, sosyalFayda: 5000)
]

// Softmax fonksiyonunu
func softmax(_ values: [Double]) -> [Double] {
    let maxVal = values.max() ?? 0  // Overflow önleme
    let expValues = values.map { exp($0 - maxVal) } // En büyük değeri çıkartarak normalize et
    let sumExpValues = expValues.reduce(0, +)
    return expValues.map { $0 / sumExpValues }
}

//Kriterleri ayrı ayrı listelenir
let nufusVerileri = mahalleler.map { $0.nufus }
let altyapiVerileri = mahalleler.map { $0.altyapi }
let maliyetVerileri = mahalleler.map { $0.maliyet }
let cevreselEtkiVerileri = mahalleler.map { $0.cevreselEtki }
let sosyalFaydaVerileri = mahalleler.map { $0.sosyalFayda }

// Softmax ağırlıkları hesaplar
let nufusAgirlik = softmax(nufusVerileri)
let altyapiAgirlik = softmax(altyapiVerileri)
let maliyetAgirlik = softmax(maliyetVerileri)
let cevreselEtkiAgirlik = softmax(cevreselEtkiVerileri)
let sosyalFaydaAgirlik = softmax(sosyalFaydaVerileri)

// En uygun güzergahı belirleme
var mahalleSkorları: [String: Double] = [:]

for (index, mahalle) in mahalleler.enumerated() {
    let toplamAgirlik = nufusAgirlik[index] + altyapiAgirlik[index] + cevreselEtkiAgirlik[index] + sosyalFaydaAgirlik[index] - maliyetAgirlik[index]
    mahalleSkorları[mahalle.ad] = toplamAgirlik
}

//En yüksek skoru olan mahalleyi seç
if let enUygun = mahalleSkorları.max(by: { $0.value < $1.value }) {
    print(" En Uygun Güzergah: \(enUygun.key) (Skor: \(enUygun.value))")
}

// Maliyet-Fayda Analizi
var faydaMaliyetOranlari: [String: Double] = [:]

for mahalle in mahalleler {
    let faydaMaliyet = (mahalle.sosyalFayda + mahalle.cevreselEtki) / mahalle.maliyet
    faydaMaliyetOranlari[mahalle.ad] = faydaMaliyet
}

// En iyi fayda/maliyet oranını seçelim
if let enIyiFaydaMaliyet = faydaMaliyetOranlari.max(by: { $0.value < $1.value }) {
    print(" En Yüksek Fayda/Maliyet Oranı: \(enIyiFaydaMaliyet.value)")
    print(" En İdeal Güzergah: \(enIyiFaydaMaliyet.key)")
}


