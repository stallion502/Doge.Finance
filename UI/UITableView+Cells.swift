//
//  UITableView+Cells.swift
//  PoocoinV2
//
//  Created by Pozdnyshev Maksim on 7/17/21.
//

import UIKit

extension UITableView {
    func basicCell(name: String,
                   detail: String? = nil,
                   indexPath: IndexPath,
                   withDisclosure: Bool = true,
                   disclosureImage: UIImage? = nil,
                   canSelect: Bool = true) -> UITableViewCell {
        let cell = dequeueCell(BasicCell.self, for: indexPath)
        cell.setTitle(name)
        cell.setDetail(detail)
        if !withDisclosure {
            cell.setDisclosureImage(disclosureImage)
        }
        if !canSelect {
            cell.selectionStyle = .none
        }
        return cell
    }

    func detailedCell(imageUrl: URL?,
                      header: String?,
                      description: String?,
                      indexPath: IndexPath,
                      canSelect: Bool = true,
                      placeholderImage: UIImage? = nil) -> UITableViewCell {
        let cell = dequeueCell(DetailedCell.self, for: indexPath)
        cell.setImage(url: imageUrl, placeholder: placeholderImage)
        cell.setHeader(header)
        cell.setDescription(description)
        if !canSelect {
            cell.selectionStyle = .none
        }

        return cell
    }
}
