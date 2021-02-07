node default {
  include(lookup('classes', {merge => unique}, ))
}
