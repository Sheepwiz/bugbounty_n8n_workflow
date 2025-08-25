# Bug Bounty Workflow Automation

This repository contains scripts and automation components for streamlining **subdomain enumeration** and **directory enumeration** in bug bounty workflows. The setup leverages `n8n`, Discord integrations, and standard offensive security tooling (Subfinder, PureDNS, Gobuster, Subwiz, httpx, etc.).

---

## Repository Contents

- **`bugbounty_workflow.json`**  
  An **n8n workflow** that integrates with Discord.  
  - Listens for bot mentions with a target domain/URL.  
  - Automatically triggers subdomain enumeration (`subenum.sh`).  
  - Organizes results into folders per target.  
  - Provides interactive options to skip/re-run enumeration.  
  - Supports directory enumeration (`direnum.sh`) and result formatting (`formatter.py`).  
  - Optionally runs `gowitness` for screenshots of discovered endpoints.

---

- **`subenum.sh`**  
  A **subdomain enumeration script**.  
  - Runs [Subfinder](https://github.com/projectdiscovery/subfinder) and [PureDNS](https://github.com/d3mondev/puredns) against the target domain.  
  - Deduplicates results and feeds them into [Subwiz](https://github.com/defparam/subwiz).  
  - Probes live hosts with [httpx](https://github.com/projectdiscovery/httpx).  
  - Saves results in a structured set of files for downstream use.

---

- **`direnum.sh`**  
  A **directory enumeration script**.  
  - Uses [Gobuster](https://github.com/OJ/gobuster) to brute force directories and files against discovered domains.  
  - Reads from `cleaned_urls.txt` (generated during subdomain enumeration).  
  - Saves results into `gobuster_results/` as text files.  

---

- **`formatter.py`**  
  A **results formatter**.  
  - Parses Gobuster result files.  
  - Extracts endpoints with **HTTP 200 (OK)** status.  
  - Rebuilds full URLs and outputs a clean list of discovered valid endpoints.  
  - Useful for feeding into `gowitness` or reporting.

---

## Usage

### 1. Import the Workflow
- Load `bugbounty_workflow.json` into your **n8n instance**.  
- Update Discord/SSH credentials as needed.  

### 2. Subdomain Enumeration
```bash
./subenum.sh target.com
```
- Results:  
  - `*_results_subfinder` – raw Subfinder output  
  - `*_combined_subwiz.txt` – deduplicated list of subdomains  
  - `httpx_results.txt` – live hosts (HTTP 200 only)  
  - `cleaned_urls.txt` – host list for directory enumeration  

### 3. Directory Enumeration
```bash
./direnum.sh
```
- Input: `cleaned_urls.txt`  
- Output: Gobuster results in `gobuster_results/`

### 4. Format Results
```bash
python3 formatter.py > results.txt
```
- Produces a clean list of valid URLs.  

### 5. (Optional) Run Gowitness
```bash
gowitness file -f results.txt
```
- Generates screenshots of discovered endpoints.  

---

## Full Guide

Detailed setup and workflow explanation can be found here:  
👉 [LampySecurity Article](https://lampysecurity.com)  

---

## Disclaimer

This project is for **educational and authorized security testing only**.  
Do **not** use these scripts against systems you do not own or have explicit permission to test.
