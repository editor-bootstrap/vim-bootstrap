package generate

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

// Plugin represents an additional vim plugin
type Plugin struct {
	Name         string   `json:"name"`
	Description  string   `json:"description"`
	Category     string   `json:"category"`
	Bundle       string   `json:"bundle"`       // Plug command
	Config       string   `json:"config"`       // Vim configuration
	Dependencies []string `json:"dependencies"` // Required plugins
	Conflicts    []string `json:"conflicts"`    // Conflicting plugins
	Tags         []string `json:"tags"`         // Search tags
}

// PluginCategory represents a category of plugins
type PluginCategory struct {
	Name        string   `json:"name"`
	Description string   `json:"description"`
	Plugins     []Plugin `json:"plugins"`
}

// PluginDatabase represents the entire plugin database
type PluginDatabase struct {
	Categories []PluginCategory `json:"categories"`
}

// loadPluginsJSON loads the plugin database from JSON file
func loadPluginsJSON() string {
	// Try to load from the plugins.json file
	jsonPath := filepath.Join("generate", "plugins.json")
	if data, err := os.ReadFile(jsonPath); err == nil {
		return string(data)
	}

	// Fallback to embedded data
	return `{
  "categories": [
    {
      "name": "File Management",
      "description": "Plugins for file and buffer management",
      "plugins": [
        {
          "name": "fzf",
          "description": "Fuzzy finder for files, buffers, and more",
          "category": "File Management",
          "bundle": "Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }\nPlug 'junegunn/fzf.vim'",
          "config": "let g:fzf_layout = { 'down': '~40%' }\nlet g:fzf_preview_window = 'right:60%'\nlet g:fzf_action = {\n  \\ 'ctrl-t': 'tab split',\n  \\ 'ctrl-x': 'split',\n  \\ 'ctrl-v': 'vsplit'\n  \\ }",
          "dependencies": [],
          "conflicts": [],
          "tags": ["fuzzy", "search", "files", "buffers"]
        },
        {
          "name": "vim-easymotion",
          "description": "Vim motions on speed!",
          "category": "File Management",
          "bundle": "Plug 'easymotion/vim-easymotion'",
          "config": "let g:EasyMotion_do_mapping = 0\nlet g:EasyMotion_smartcase = 1\nmap <Leader>j <Plug>(easymotion-j)\nmap <Leader>k <Plug>(easymotion-k)",
          "dependencies": [],
          "conflicts": [],
          "tags": ["motion", "navigation", "jump"]
        }
      ]
    }
  ]
}`
}

var pluginDB *PluginDatabase

// GetPluginDatabase returns the plugin database
func GetPluginDatabase() *PluginDatabase {
	if pluginDB == nil {
		pluginDB = &PluginDatabase{}
		pluginsJSON := loadPluginsJSON()
		if err := json.Unmarshal([]byte(pluginsJSON), pluginDB); err != nil {
			// Fallback to empty database if JSON parsing fails
			pluginDB = &PluginDatabase{Categories: []PluginCategory{}}
		}
	}
	return pluginDB
}

// ListPluginCategories returns all available plugin categories
func ListPluginCategories() []PluginCategory {
	db := GetPluginDatabase()
	return db.Categories
}

// ListPlugins returns all available plugins
func ListPlugins() []Plugin {
	db := GetPluginDatabase()
	var plugins []Plugin
	for _, category := range db.Categories {
		plugins = append(plugins, category.Plugins...)
	}
	return plugins
}

// GetPluginsByCategory returns plugins for a specific category
func GetPluginsByCategory(categoryName string) []Plugin {
	db := GetPluginDatabase()
	for _, category := range db.Categories {
		if category.Name == categoryName {
			return category.Plugins
		}
	}
	return []Plugin{}
}

// GetPluginByName returns a specific plugin by name
func GetPluginByName(name string) *Plugin {
	plugins := ListPlugins()
	for _, plugin := range plugins {
		if plugin.Name == name {
			return &plugin
		}
	}
	return nil
}

// ValidatePluginSelection validates a list of selected plugins
func ValidatePluginSelection(selectedPlugins []string) ([]string, []string, error) {
	var warnings []string
	var errors []string

	plugins := ListPlugins()
	pluginMap := make(map[string]Plugin)
	for _, plugin := range plugins {
		pluginMap[plugin.Name] = plugin
	}

	// Check if all selected plugins exist
	for _, pluginName := range selectedPlugins {
		if _, exists := pluginMap[pluginName]; !exists {
			errors = append(errors, fmt.Sprintf("Plugin '%s' not found", pluginName))
		}
	}

	// Check for conflicts
	for i, pluginName1 := range selectedPlugins {
		plugin1, exists1 := pluginMap[pluginName1]
		if !exists1 {
			continue
		}

		for j, pluginName2 := range selectedPlugins {
			if i >= j {
				continue
			}

			plugin2, exists2 := pluginMap[pluginName2]
			if !exists2 {
				continue
			}

			// Check if plugin1 conflicts with plugin2
			for _, conflict := range plugin1.Conflicts {
				if conflict == pluginName2 {
					warnings = append(warnings, fmt.Sprintf("Plugin '%s' may conflict with '%s'", pluginName1, pluginName2))
				}
			}

			// Check if plugin2 conflicts with plugin1
			for _, conflict := range plugin2.Conflicts {
				if conflict == pluginName1 {
					warnings = append(warnings, fmt.Sprintf("Plugin '%s' may conflict with '%s'", pluginName2, pluginName1))
				}
			}
		}
	}

	// Check dependencies
	for _, pluginName := range selectedPlugins {
		plugin, exists := pluginMap[pluginName]
		if !exists {
			continue
		}

		for _, dep := range plugin.Dependencies {
			found := false
			for _, selected := range selectedPlugins {
				if selected == dep {
					found = true
					break
				}
			}
			if !found {
				warnings = append(warnings, fmt.Sprintf("Plugin '%s' requires '%s' (not selected)", pluginName, dep))
			}
		}
	}

	return warnings, errors, nil
}

// GetAdditionalPluginsConfig returns the configuration for selected additional plugins
func GetAdditionalPluginsConfig(selectedPlugins []string) (map[string]Plugin, error) {
	config := make(map[string]Plugin)

	for _, pluginName := range selectedPlugins {
		plugin := GetPluginByName(pluginName)
		if plugin != nil {
			config[pluginName] = *plugin
		}
	}

	return config, nil
}
