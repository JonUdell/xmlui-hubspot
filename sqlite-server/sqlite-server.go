    package main

    import (
        "bytes"
        "database/sql"
        "encoding/json"
        "io"
        "log"
        "net/http"
        "os"
        "path/filepath"

        _ "github.com/mattn/go-sqlite3"
    )

    type QueryRequest struct {
        SQL    string         `json:"sql"`
        Params []interface{} `json:"params"`
    }

    type Server struct {
        db *sql.DB
    }

    func NewServer(dbPath string) (*Server, error) {
        db, err := sql.Open("sqlite3", dbPath)
        if err != nil {
            return nil, err
        }
        return &Server{db: db}, nil
    }

    func (s *Server) handleQuery(w http.ResponseWriter, r *http.Request) {
        log.Printf("Handling query request from %s", r.URL.Path)
        
        if r.Method != "POST" {
            http.Error(w, "Only POST method is allowed", http.StatusMethodNotAllowed)
            return
        }

        // Use io.TeeReader to log the body while still allowing it to be read
        var bodyBuffer bytes.Buffer
        teeReader := io.TeeReader(r.Body, &bodyBuffer)

        // Log the body as a string
        bodyBytes, err := io.ReadAll(teeReader)
        if err != nil {
            http.Error(w, "Failed to read request body", http.StatusInternalServerError)
            return
        }
        log.Printf("Request Body: %s", string(bodyBytes))

        // Decode the body into the QueryRequest struct
        var req QueryRequest
        if err := json.NewDecoder(&bodyBuffer).Decode(&req); err != nil {
            http.Error(w, err.Error(), http.StatusBadRequest)
            return
        }    

        rows, err := s.db.Query(req.SQL, req.Params...)
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }
        defer rows.Close()

        columns, err := rows.Columns()
        if err != nil {
            http.Error(w, err.Error(), http.StatusInternalServerError)
            return
        }

        var result []map[string]interface{}
        for rows.Next() {
            values := make([]interface{}, len(columns))
            valuePtrs := make([]interface{}, len(columns))
            for i := range columns {
                valuePtrs[i] = &values[i]
            }

            if err := rows.Scan(valuePtrs...); err != nil {
                http.Error(w, err.Error(), http.StatusInternalServerError)
                return
            }

            entry := make(map[string]interface{})
            for i, col := range columns {
                var v interface{}
                val := values[i]
                b, ok := val.([]byte)
                if ok {
                    v = string(b)
                } else {
                    v = val
                }
                entry[col] = v
            }
            result = append(result, entry)
        }

        w.Header().Set("Content-Type", "application/json")
        json.NewEncoder(w).Encode(result)
    }

    func main() {
        // Set up logging
        log.SetFlags(log.Lshortfile | log.LstdFlags)
        log.Println("Server starting...")

        // Print current working directory
        pwd, err := os.Getwd()
        if err != nil {
            log.Fatal(err)
        }
        log.Printf("Working directory: %s", pwd)

        // List files in current directory
        files, err := filepath.Glob("*")
        if err != nil {
            log.Fatal(err)
        }
        log.Printf("Files in directory: %v", files)

        // Initialize server
        server, err := NewServer("data.db")
        if err != nil {
            log.Fatal(err)
        }

        // Create router
        mux := http.NewServeMux()

        // Handle root and static files
        mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
            log.Printf("Received request for: %s", r.URL.Path)
            
            // If root path, try to serve index.html
            if r.URL.Path == "/" {
                log.Println("Trying to serve index.html")
                http.ServeFile(w, r, "index.html")
                return
            }

            // Otherwise serve the requested file
            filePath := "." + r.URL.Path
            log.Printf("Trying to serve: %s", filePath)
            if _, err := os.Stat(filePath); os.IsNotExist(err) {
                log.Printf("File not found: %s", filePath)
                http.NotFound(w, r)
                return
            }
            http.ServeFile(w, r, filePath)
        })

        // Handle queries
        mux.HandleFunc("/query", server.handleQuery)

        // Start server
        port := os.Getenv("PORT")
        if port == "" {
            port = "8080"
        }

        log.Printf("Server listening on port %s...", port)
        if err := http.ListenAndServe(":"+port, mux); err != nil {
            log.Fatal(err)
        }
    }