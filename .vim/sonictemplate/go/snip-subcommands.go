package main

import (
	"github.com/google/subcommands"
)

type {{_input_:name}} struct {
}

func (*{{_input_:name}}) Name() string     { return "{{_input_:name}}" }
func (*{{_input_:name}}) Synopsis() string { return "{{_input_:Synopsis}}" }
func (*{{_input_:name}}) Usage() string {
	return `useage`
}

func (p *{{_input_:name}}) SetFlags(f *flag.FlagSet) {
	// f.BoolVar(&p.capitalize, "capitalize", false, "capitalize output")
	// f.StringVar(&p.targetPath, "target path", "output", "output directory")
}

func (p *{{_input_:name}}) Execute(ctx context.Context, f *flag.FlagSet, _ ...interface{}) subcommands.ExitStatus {
	log.Println("Exec")

	if err != nil {
		log.Println(err)
		return subcommands.ExitFailure
	}
	return subcommands.ExitSuccess
}

