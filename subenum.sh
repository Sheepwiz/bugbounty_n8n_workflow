#!/bin/bash

# Check if domain was provided
if [ -z "$1" ]; then
  echo "Usage: $0 domain.com"
  exit 1
fi

DOMAIN="$1"
DOMAIN_NO_DOTS=$(echo "$DOMAIN" | tr '.' '_')

echo "[*] Running subfinder..."
/root/go/bin/subfinder -d "$DOMAIN" -o "${DOMAIN_NO_DOTS}_results_subfinder"

echo "[*] Resolving with PureDNS..."
cat "${DOMAIN_NO_DOTS}_results_subfinder" | puredns resolve -r /root/puredns/massdns/lists/resolvers.txt > "${DOMAIN_NO_DOTS}_puredns_resolve.txt"
awk '/^Found [0-9]+ valid domains:/{flag=1; next} flag' "${DOMAIN_NO_DOTS}_puredns_resolve.txt" > "${DOMAIN_NO_DOTS}_puredns_valid.txt"

echo "[*] Combining and deduplicating all subdomains..."
cat "${DOMAIN_NO_DOTS}_results_subfinder" "${DOMAIN_NO_DOTS}_puredns_valid.txt" | sort -u > "${DOMAIN_NO_DOTS}_combined.txt"

echo "[*] Running Subwiz..."
source ~/discord/bugbounty/bin/activate
subwiz -i "${DOMAIN_NO_DOTS}_combined.txt" -n 1000 -o "${DOMAIN_NO_DOTS}_subwiz.txt"
cat "${DOMAIN_NO_DOTS}_combined.txt" "${DOMAIN_NO_DOTS}_subwiz.txt" | sort -u > "${DOMAIN_NO_DOTS}_combined_subwiz.txt"

echo "[*] Running httpx..."
/root/go/bin/httpx -l "${DOMAIN_NO_DOTS}_combined_subwiz.txt" -title -status-code -fr | grep 200 > "httpx_results.txt"
cut -d' ' -f1 httpx_results.txt > cleaned_urls.txt

rm "${DOMAIN_NO_DOTS}_puredns_valid.txt"
echo "[*] Done! Results saved to:"
echo "  - Subfinder: ${DOMAIN_NO_DOTS}_results_subfinder"
echo "  - Combined: ${DOMAIN_NO_DOTS}_combined_subwiz.txt"
echo "  - Httpx: httpx_results.txt"
