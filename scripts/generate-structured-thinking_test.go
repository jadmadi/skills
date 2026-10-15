package main

import (
	"bytes"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func fixture(t *testing.T) string {
	t.Helper()
	root := t.TempDir()
	source := filepath.Join("..", "skills", "structured-thinking")
	err := filepath.WalkDir(source, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(source, path)
		if err != nil {
			return err
		}
		target := filepath.Join(root, "skills", "structured-thinking", rel)
		if d.IsDir() {
			return os.MkdirAll(target, 0755)
		}
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		return os.WriteFile(target, data, 0644)
	})
	if err != nil {
		t.Fatal(err)
	}
	return root
}

func TestGenerate(t *testing.T) {
	root := fixture(t)
	if err := generate(root, true); err == nil {
		t.Fatal("missing outputs accepted")
	}
	if err := generate(root, false); err != nil {
		t.Fatal(err)
	}
	if err := generate(root, true); err != nil {
		t.Fatal(err)
	}
	files, _ := filepath.Glob(filepath.Join(root, "skills", "st-*", "SKILL.md"))
	if len(files) != 25 {
		t.Fatalf("got %d outputs", len(files))
	}
	for _, path := range files {
		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatal(err)
		}
		slug := strings.TrimPrefix(filepath.Base(filepath.Dir(path)), "st-")
		if slug == "six-hats" {
			slug = "six-thinking-hats"
		}
		guide, err := os.ReadFile(filepath.Join(root, "skills", "structured-thinking", "references", slug+".md"))
		if err != nil {
			t.Fatal(err)
		}
		_, body, _ := strings.Cut(string(guide), "\n")
		if !bytes.Contains(data, []byte(body)) {
			t.Fatalf("method body lost: %s", slug)
		}
		if bytes.Contains(data, []byte("](references/")) {
			t.Fatalf("external skill dependency: %s", slug)
		}
	}
	path := files[0]
	if err := os.WriteFile(path, []byte("user-authored skill\n"), 0644); err != nil {
		t.Fatal(err)
	}
	if err := generate(root, true); err == nil {
		t.Fatal("drift accepted")
	}
	if err := generate(root, false); err == nil {
		t.Fatal("unmanaged overwrite accepted")
	}
	data, _ := os.ReadFile(path)
	if string(data) != "user-authored skill\n" {
		t.Fatal("unmanaged file changed")
	}
}

func TestInvalidSourceDoesNotWrite(t *testing.T) {
	root := fixture(t)
	path := filepath.Join(root, "skills", "structured-thinking", "references", "six-thinking-hats.md")
	if err := os.WriteFile(path, []byte("invalid guide"), 0644); err != nil {
		t.Fatal(err)
	}
	if err := generate(root, false); err == nil {
		t.Fatal("invalid source accepted")
	}
	files, _ := filepath.Glob(filepath.Join(root, "skills", "st-*", "SKILL.md"))
	if len(files) != 0 {
		t.Fatal("partial outputs written")
	}
}
