// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainAudit {
    struct AuditEntry {
        address auditor;
        bytes32 dataHash;
        uint256 timestamp;
        string notes;
    }

    mapping(bytes32 => AuditEntry[]) public auditTrail;
    mapping(address => bool) public auditors;

    event AuditRecorded(bytes32 indexed recordId, address indexed auditor, bytes32 dataHash);
    event AuditorAdded(address indexed auditor);

    error NotAuditor();

    function addAuditor(address auditor) external {
        auditors[auditor] = true;
        emit AuditorAdded(auditor);
    }

    function recordAudit(bytes32 recordId, bytes32 dataHash, string memory notes) external {
        if (!auditors[msg.sender]) revert NotAuditor();
        auditTrail[recordId].push(AuditEntry({
            auditor: msg.sender,
            dataHash: dataHash,
            timestamp: block.timestamp,
            notes: notes
        }));
        emit AuditRecorded(recordId, msg.sender, dataHash);
    }

    function getAuditTrail(bytes32 recordId) external view returns (AuditEntry[] memory) {
        return auditTrail[recordId];
    }

    function verifyAudit(bytes32 recordId, uint256 index, bytes32 expectedHash) external view returns (bool) {
        return auditTrail[recordId][index].dataHash == expectedHash;
    }
}
