//
//  GitHubService.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/09.
//

import Foundation

/**
 GitHub REST API에서 제공하는 기능 중에 GitSpace 앱 내에서 사용할 기능들을 정리합니다.
 - Author: 제균
 */
protocol GitHubServiceProtocol {
    
    /// 인증된 사용자의 정보를 요청하는 함수
    func requestAuthenticatedUser() async -> Result<GithubUser, GitHubAPIError>
    
    /// 인증된 사용자의 starred repository들을 요청하는 함수
    func requestAuthenticatedUserStars(page: Int) async -> Result<[RepositoryResponse], GitHubAPIError>
    
    /// 인증된 사용자가 액세스 권한을 가진 repository들을 요청하는 함수
    func requestAuthenticatedUserRepositories(page: Int) async -> Result<[RepositoryResponse], GitHubAPIError>
    
    /// 인증된 사용자가 팔로우하고 있는지의 여부를 확인하는 함수
    func requestAuthenticatedUserFollowsPerson(userName: String) async throws

    /// 인증된 사용자의 follower 목록을 요청하는 함수
    func requestAuthenticatedUserFollowers(perPage: Int, page: Int) async -> Result<[FollowerResponse], GitHubAPIError>

    /// 인증된 사용자로 받은 이벤트를 요청하는 함수
    func requestAuthenticatedUserReceivedEvents(userName: String, page: Int) async -> Result<[Event],GitHubAPIError>

    /// 인증된 사용자로 특정 레포지토리를 star할 때 사용하는 함수
    func requestToStarRepository(owner: String, repositoryName: String) async throws
    
    /// 인증된 사용자로 특정 레포지토리를 unstar할 때 사용하는 함수
    func requestToUnstarRepository(owner: String, repositoryName: String) async throws
    
    /// 특정 유저를 follow 할 때 사용하는 함수
    func requestToFollowUser(userName: String) async throws
    
    // 특정 유저를 unfollow 할 때 사용하는 함수
    func requestToUnfollowUser(userName: String) async throws
    
    /// 특정 유저의 정보를 요청하는 함수
    func requestUserInformation(userName: String) async -> Result<GithubUser, GitHubAPIError>
    
    /// 특정 유저의 starred repository들을 요청하는 함수
    func requestUserStarRepositories(userName: String, page: Int) async -> Result<[RepositoryResponse], GitHubAPIError>
    
    /// 특정 유저의 Following List를 요청하는 함수
    func requestUserFollowingList(userName: String, perPage: Int, page: Int) async -> Result<[FollowingResponse], GitHubAPIError>
    
    /// 특정 유저의 Follower List를 요청하는 함수
    func requestUserFollowerList(userName: String, perPage: Int, page: Int) async -> Result<[FollowingResponse], GitHubAPIError>
    
    /// 특정 레포지토리의 정보를 요청하는 함수
    func requestRepositoryInformation(owner: String, repositoryName: String) async -> Result<Repository, GitHubAPIError>
    
    /// 특정 레포지토리의 리드미를 요청하는 함수
    func requestRepositoryReadme(owner: String, repositoryName: String) async -> Result<RepositoryReadmeResponse, GitHubAPIError>
    
    /// 마크다운 text를 HTML로 변환하는 함수
    func requestMarkdownToHTML(content: String) async -> Result<String, GitHubAPIError>
    
    /// 특정 레포지토리의 contributor 목록을 요청하는 함수
    func requestRepositoryContributors(owner: String, repositoryName: String, page: Int) async -> Result<[ContributorProfile], GitHubAPIError>
    
    // TODO: - 필요한 API 기능을 추가로 작성합니다.
}

/// GitHubService 구현부
struct GitHubService: HTTPClient, GitHubServiceProtocol {
    
    /**
     인증된 유저의 계정으로 특정 유저를 팔로우합니다.
     - Author: 제균
     - returns: 요청 성공시 성공했다는 string을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestToFollowUser(userName: String) async throws {
        return try await sendRequest(endpoint: GitHubAPIEndpoint.followUser(userName: userName))
    }
    
    /**
     인증된 유저의 계정으로 특정 유저를 언팔로우합니다.
     - Author: 제균
     - returns: 요청 성공시 성공했다는 string을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestToUnfollowUser(userName: String) async throws {
        return try await sendRequest(endpoint: GitHubAPIEndpoint.unfollowUser(userName: userName))
    }
    
    /**
     인증된 유저가 특정 유저를 팔로우하는지 여부를 API에 요청합니다.
     - Author: 제균
     - returns: 요청 성공시 성공했다는 string을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestAuthenticatedUserFollowsPerson(userName: String) async throws {
        return try await sendRequest(endpoint: GitHubAPIEndpoint.authenticatedUserFollowsPerson(userName: userName))
    }
    
    /**
     인증된 유저의 팔로워 목록을 불러옵니다.
     - Author: 제균
     - returns: 요청 성공시 유저 정보 모델을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestAuthenticatedUserFollowers(perPage: Int, page: Int) async -> Result<[FollowerResponse], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.authenticatedUserFollowers(perPage: 100, page: page), responseModel: [FollowerResponse].self)
    }
    
    /**
     인증된 유저의 정보를 요청합니다.
     - Author: 제균
     - returns: 요청 성공시 유저 정보 모델을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestAuthenticatedUser() async -> Result<GithubUser, GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.authenticatedUserInformation, responseModel: GithubUser.self)
    }
    
    /**
     인증된 유저의 레포지토리 목록를 요청합니다.
     - Author: 제균
     - parameters:
        - page: 요청할 page number
     - returns: 요청 성공시 유저가 권한을 가진 레포지토리 목록을, 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestAuthenticatedUserRepositories(page: Int) async -> Result<[RepositoryResponse], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.authenticatedUserRepositories(page: page), responseModel: [RepositoryResponse].self)
    }
    
    /**
     인증된 유저의 star repositories를 요청합니다.
     - Author: 제균
     - parameters:
        - page: 요청할 page number
     - returns: 요청 성공시 유저가 star를 눌러둔 레포지토리 목록을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestAuthenticatedUserStars(page: Int) async -> Result<[RepositoryResponse], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.authenticatedUserStarRepositories(page: page), responseModel: [RepositoryResponse].self)
    }
    
    /**
     인증된 유저의 received events를 요청합니다.
     - Author: 제균
     - parameters:
        - page: 요청할 page number
     - returns: 요청 성공시 유저가 받은 Event 목록을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestAuthenticatedUserReceivedEvents(userName: String, page: Int) async -> Result<[Event], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.authenticatedUserReceivedEvents(userName: userName, page: page), responseModel: [Event].self)
    }
    
    /**
     인증된 사용자의 계정으로 특정 레포지토리를 star하는 PUT 요청을 보냅니다.
     - Author: 제균
     - parameters:
        - owner: 레포지토리 주인의 userName
        - repositoryName: star를 누를 대상 레포지토리의 이름
     - returns: 요청 성공시 성공했다는 string을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestToStarRepository(owner: String, repositoryName: String) async throws {
        return try await sendRequest(endpoint: GitHubAPIEndpoint.starRepository(owner: owner, repositoryName: repositoryName))
    }
    
    /**
     인증된 사용자의 계정으로 특정 레포지토리를 star하는 DELETE 요청을 보냅니다.
     - Author: 제균
     - parameters:
        - owner: 레포지토리 주인의 userName
        - repositoryName: star를 해제할 대상 레포지토리의 이름
     - returns: 요청 성공시 성공했다는 string을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestToUnstarRepository(owner: String, repositoryName: String) async throws {
        return try await sendRequest(endpoint: GitHubAPIEndpoint.unstarRepository(owner: owner, repositoryName: repositoryName))
    }
    
    /**
     특정 유저의 Public 정보를 요청합니다.
     - Author: 제균
     - parameters:
        - userName: GitHub userName
     - returns: 요청 성공시 유저 정보 모델을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestUserInformation(userName: String) async -> Result<GithubUser, GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.userInformation(userName: userName), responseModel: GithubUser.self)
    }
    
    /**
     특정 유저의 starred repository 정보를 요청합니다.
     - Author: 제균
     - parameters:
        - userName: GitHub userName
        - page: 요청할 page number
     - returns: 요청 성공시 특정 유저가 star를 눌러둔 레포지토리 목록을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestUserStarRepositories(userName: String, page: Int) async -> Result<[RepositoryResponse], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.userStarRepositories(userName: userName, page: page), responseModel: [RepositoryResponse].self)
    }
    
    /**
     특정 유저의 Following List 정보를 요청합니다.
     - Author: 한호
     - parameters:
        - userName: GitHub userName
        - perPage: page 당 요청할 개수(default: 30, max: 100)
        - page: 요청할 page number
     - returns: 요청 성공시 특정 유저의 Following 목록을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestUserFollowingList(userName: String, perPage: Int, page: Int) async -> Result<[FollowingResponse], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.userFollowingList(userName: userName, perPage: perPage, page: page), responseModel: [FollowingResponse].self)
    }
    
    /**
     특정 유저의 Follower List 정보를 요청합니다.
     - Author: 한호
     - parameters:
        - userName: GitHub userName
        - perPage: page 당 요청할 개수(default: 30, max: 100)
        - page: 요청할 page numbe
     - returns: 요청 성공시 특정 유저의 Follower 목록을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestUserFollowerList(userName: String, perPage: Int, page: Int) async -> Result<[FollowingResponse], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.userFollowerList(userName: userName, perPage: perPage, page: page), responseModel: [FollowingResponse].self)
    }
    
    /**
     특정 레포지토리의 정보를 요청합니다.
     - Author: 제균
     - parameters:
        - owner: 레포지토리 주인의 userName
        - repositoryName: 레포지토리의 이름
     - returns: 요청 성공시 레포지토리 모델을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestRepositoryInformation(owner: String, repositoryName: String) async -> Result<Repository, GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.repositoryInformation(owner: owner, repositoryName: repositoryName), responseModel: Repository.self)
    }
    
    /**
     특정 레포지토리의 리드미를 요청합니다.
     - Author: 제균
     - parameters:
        - owner: 레포지토리 주인의 userName
        - repositoryName: 레포지토리의 이름
     - returns: 요청 성공시 레포지토리의 readme를 담고있는 모델을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestRepositoryReadme(owner: String, repositoryName: String) async -> Result<RepositoryReadmeResponse, GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.repositoryREADME(owner: owner, repositoryName: repositoryName), responseModel: RepositoryReadmeResponse.self)
    }
    
    /**
     마크다운 String을 HTML String으로 변환하도록 요청합니다.
     - Author: 제균
     - parameters:
        - content: html 문자열로 변환할 마크다운 문자열
     - returns: 요청 성공시 HTML 문자열을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestMarkdownToHTML(content: String) async -> Result<String, GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.markdownToHTML(markdownString: content))
    }
    
    /**
     특정 레포지토리의 contributor 목록을 요청합니다.
     - Author: 제균
     - parameters:
        - owner: 레포지토리 주인의 userName
        - repositoryName: 대상 레포지토리의 이름
        - page: 요청할 페이지 number
     - returns: 요청 성공시 성공했다는 Contributor의 목록을, 요청 실패시 GitHubAPIError를 가지는 Result 타입을 리턴합니다.
     */
    func requestRepositoryContributors(owner: String, repositoryName: String, page: Int) async -> Result<[ContributorProfile], GitHubAPIError> {
        return await sendRequest(endpoint: GitHubAPIEndpoint.repositoryContributors(owner: owner, repositoryName: repositoryName, page: page), responseModel: [ContributorProfile].self)
    }
    
}
