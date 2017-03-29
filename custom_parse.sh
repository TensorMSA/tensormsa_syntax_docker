PARSER_EVAL=bazel-bin/syntaxnet/parser_eval
CONTEXT=syntaxnet/models/parsey_universal/context.pbtxt
if [[ "$1" == "--conll" ]]; then
  INPUT_FORMAT=stdin-conll
  shift
else
  INPUT_FORMAT=stdin
fi
MODEL_DIR=$1

$PARSER_EVAL \
  --input=$INPUT_FORMAT \
  --output=stdout-conll \
  --hidden_layer_sizes=64 \
  --arg_prefix=brain_morpher \
  --graph_builder=structured \
  --task_context=$CONTEXT \
  --resource_dir=$MODEL_DIR \
  --model_path=$MODEL_DIR/morpher-params \
  --slim_model \
  --batch_size=1024 \
  --alsologtostderr \
  | \
  $PARSER_EVAL \
  --input=stdin-conll \
  --output=stdout-conll \
  --hidden_layer_sizes=64 \
  --arg_prefix=brain_tagger \
  --graph_builder=structured \
  --task_context=$CONTEXT \
  --resource_dir=$MODEL_DIR \
  --model_path=$MODEL_DIR/tagger-params \
  --slim_model \
  --batch_size=1024 \
  --alsologtostderr \
  | \
  $PARSER_EVAL \
  --input=stdin-conll \
  --output=stdout-conll \
  --hidden_layer_sizes=512,512 \
  --arg_prefix=brain_parser \
  --graph_builder=structured \
  --task_context=$CONTEXT \
  --resource_dir=$MODEL_DIR \
  --model_path=$MODEL_DIR/parser-params \
  --slim_model \
  --batch_size=1024 \
  --alsologtostderr
