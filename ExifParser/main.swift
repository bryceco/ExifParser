//
//  main.swift
//  ExifParser
//
//  Created by Bryce Cogswell on 3/24/23.
//

import Foundation

exifTest()

func compare(data: Data) -> Bool {
	let exifCpp = ExifGeolocation(data: data)
	let exifSwift = try? EXIFInfo(from: data)
	if exifCpp == nil && exifSwift == nil {
		return true
	}
	guard let exifSwift = exifSwift else {
		print("missing swift")
		return false
	}
	guard let exifCpp = exifCpp else {
		print("missing cpp")
		return false
	}
	guard exifCpp.location().coordinate.latitude == (exifSwift.gps.latComponents.decimal ?? 0.0),
		  exifCpp.location().coordinate.longitude == (exifSwift.gps.lonComponents.decimal ?? 0.0),
		  exifCpp.location().course == (exifSwift.gps.imgDirection ?? 0.0),
		  exifCpp.lensModel() == (exifSwift.exifIFD.lensInfo.model ?? "")
	else {
		print("Diff")
		return false
	}
	return true
}

func forAllFiles(in path: String) {
	let url = URL(fileURLWithPath: path)
	if let enumerator = FileManager.default.enumerator(at: url,
													   includingPropertiesForKeys: [.isRegularFileKey,
																					.isDirectoryKey],
													   options: [],
													   errorHandler: { url, error in
		print("\(error)")
		return true })
	{
		for case let fileURL as URL in enumerator {
			do {
				let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
				if fileAttributes.isRegularFile! {
					if let data = try? Data(contentsOf: fileURL, options: .alwaysMapped) {
						print("\(fileURL.absoluteString)")
						var isEqual = compare(data: data)
						while !isEqual {
							isEqual = compare(data: data)
						}
					} else {
						print("Couldn't read \(fileURL.absoluteString)")
					}
				}
			} catch { print(error, fileURL) }
		}
	}
}

public func exifTest() {
	let root = "/Users/bryce/Pictures/Photos Library.photoslibrary/originals"
	forAllFiles(in: root)
}
