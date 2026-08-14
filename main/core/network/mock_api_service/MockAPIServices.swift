//
//  MockAPIServices.swift
//  FrameInvaders
//
//  Created by ibarts on 17/07/26.
//

final class MockAPIClient: APIClientProtocol {

    var shouldShowError: Bool = false
    
    func request<T>(type: any EndPointType) async throws -> T where T : Decodable, T : Encodable {
        defer { shouldShowError = false }
        if shouldShowError {
            throw NSError(
                domain: "MockAPIService",
                code: 500,
                userInfo: [NSLocalizedDescriptionKey: "Mock API Failure"]
            )
        }else {
            return try loadJson(filename: type.mockFileName)
        }
    }
}

extension MockAPIClient {

    func loadJson<T: Decodable>(filename fileName: String) throws -> T {
        guard !fileName.isEmpty else {
            throw DataError.invalidURL
        }

        // Search main app bundle + any active test bundles (.xctest)
        let searchBundles = [Bundle(for: MockAPIClient.self), Bundle.main]
            + Bundle.allBundles.filter { $0.bundlePath.hasSuffix(".xctest") }

        for bundle in searchBundles {
            if let url = bundle.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(T.self, from: data)
            }
        }

        throw DataError.invalidURL
    }

}
