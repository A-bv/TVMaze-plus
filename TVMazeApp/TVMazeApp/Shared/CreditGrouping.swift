//
//  CreditGrouping.swift
//  TVMazeApp
//
//  Created by Alexandre Bevilacqua on 10.11.2026.
//

enum CreditGrouping {
    private static let roleSeparator = " · "

    static func group<Owner>(
        _ credits: [(owner: Owner, role: String)],
        id: (Owner) -> Int
    ) -> [(owner: Owner, role: String)] {
        var owners: [Owner] = []
        var roles: [Int: [String]] = [:]
        for credit in credits {
            let key = id(credit.owner)
            if roles[key] == nil {
                owners.append(credit.owner)
            }
            if roles[key]?.contains(credit.role) != true {
                roles[key, default: []].append(credit.role)
            }
        }
        return owners.map { owner in
            (owner, roles[id(owner), default: []].joined(separator: roleSeparator))
        }
    }
}
