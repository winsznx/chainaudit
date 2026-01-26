;; ChainAudit - Immutable audit trail system
(define-constant ERR-NOT-AUDITOR (err u100))

(define-map audit-entries
    { record-id: (buff 32), index: uint }
    { auditor: principal, data-hash: (buff 32), timestamp: uint, notes: (string-ascii 256) }
)

(define-map audit-counts { record-id: (buff 32) } { count: uint })
(define-map auditors { auditor: principal } { is-auditor: bool })

(define-public (add-auditor (auditor principal))
    (begin
        (map-set auditors { auditor: auditor } { is-auditor: true })
        (ok true)
    )
)

(define-public (record-audit (record-id (buff 32)) (data-hash (buff 32)) (notes (string-ascii 256)))
    (let (
        (entry-index (default-to u0 (get count (map-get? audit-counts { record-id: record-id }))))
    )
        (asserts! (default-to false (get is-auditor (map-get? auditors { auditor: tx-sender }))) ERR-NOT-AUDITOR)
        (map-set audit-entries { record-id: record-id, index: entry-index } {
            auditor: tx-sender,
            data-hash: data-hash,
            timestamp: block-height,
            notes: notes
        })
        (map-set audit-counts { record-id: record-id } { count: (+ entry-index u1) })
        (ok entry-index)
    )
)

(define-read-only (get-audit-entry (record-id (buff 32)) (index uint))
    (map-get? audit-entries { record-id: record-id, index: index })
)

(define-read-only (get-audit-count (record-id (buff 32)))
    (default-to u0 (get count (map-get? audit-counts { record-id: record-id })))
)
