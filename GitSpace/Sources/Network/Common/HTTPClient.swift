//
//  HTTPClient.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/09.
//

import Foundation

/**
 Client측에서 채택해야 할 프로토콜, requset를 보내는 sendRequest 함수가 있다.
 - Author: 제균
 */
protocol HTTPClient {
    /**
     HTTP request를 보내고, 성공시 지정한 model을 돌려받을 수 있다.
     실패시 error를 받는다.
     */
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, GitHubAPIError>
    /**
     response로 status code와 함께 string을 받는 경우(Markdown)
     */
    func sendRequest(endpoint: Endpoint) async -> Result<String, GitHubAPIError>

    /**
     response로 status code만 받는 경우 (star, unstar, follow, unfollow)
     status code만 받기 때문에, 204를 만나면 break, 나머지 코드를 받으면 error를 throw한다.
     */
    func sendRequest(endpoint: Endpoint) async throws
}

// MARK: - sendRequest의 구현부

extension HTTPClient {

    func sendRequest<T: Decodable>(
        endpoint: Endpoint,
        responseModel: T.Type) async -> Result<T, GitHubAPIError> {

        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            return .failure(GitHubAPIError.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                return .failure(GitHubAPIError.invalidResponse)
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.failToDecoding)
                }
                return .success(decodedResponse)
            default:
                return .failure(.unexpectedStatusCode)
            }

        } catch {
            return .failure(.unknown)
        }
    }

    func sendRequest(endpoint: Endpoint) async -> Result<String, GitHubAPIError> {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            return .failure(GitHubAPIError.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                return .failure(GitHubAPIError.invalidResponse)
            }

            switch response.statusCode {
                
            case 200:
                guard let resultString = String(data: data, encoding: .utf8) else {
                    return .failure(.failToEncoding)
                }
                return .success(resultString)
            case 204:
                return .success("request succeed")
            case 304:
                return .failure(.notModified)
            case 401:
                return .failure(.requiresAuthentification)
            case 403:
                return .failure(.forbidden)
            case 404:
                return .failure(.notFound)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
    func sendRequest(endpoint: Endpoint) async throws {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems

        guard let url = components.url else {
            throw GitHubAPIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header

        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let ( _, response) = try await URLSession.shared.data(for: request)

            guard let response = response as? HTTPURLResponse else {
                throw GitHubAPIError.invalidResponse
            }

            switch response.statusCode {
                // 204를 만나면 에러 없이 종료
            case 204:
                break
            case 304:
                throw GitHubAPIError.notModified
            case 401:
                throw GitHubAPIError.requiresAuthentification
            case 403:
                throw GitHubAPIError.forbidden
            case 404:
                throw GitHubAPIError.notFound
            default:
                throw GitHubAPIError.unexpectedStatusCode
            }

        } catch {
            throw GitHubAPIError.unknown
        }
    }

}




